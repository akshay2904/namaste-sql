"""
Execute every datadriven/*.py PySpark solution against small synthetic
DataFrames built from the sample data embedded in its matching .sql file,
using one local SparkSession. This won't validate logical correctness
against the full (unseen, millions-of-rows) dataset, but it does catch real
crashes: hallucinated API calls, wrong column references, type errors,
import errors -- the kind of thing spot-checks turned up in the LLM output.

Usage:
    python verify_pyspark.py            # verify all .py files present
    python verify_pyspark.py --delete-broken   # also delete files that crash
"""
import ast
import os
import re
import sys
import traceback

os.environ.setdefault("JAVA_HOME", r"C:\Users\aksha\.jdk\jdk-17.0.20+8")

DD_DIR = os.path.join(os.path.dirname(__file__), "datadriven")

TABLE_RE = re.compile(r"Sample data - (\w+) (\[.*?\]):\n((?:  \[.*\]\n?)+)")


def parse_tables(question: str) -> dict[str, list[dict]]:
    """Return {table_name: [ {col: val, ...}, ... ]} from the .sql comment block."""
    tables = {}
    for name, cols_literal, rows_block in TABLE_RE.findall(question):
        columns = ast.literal_eval(cols_literal)
        rows = []
        for line in rows_block.strip("\n").split("\n"):
            line = line.strip()
            if not line:
                continue
            try:
                values = ast.literal_eval(line)
            except (ValueError, SyntaxError):
                continue
            rows.append(dict(zip(columns, values)))
        tables[name] = rows
    return tables


def infer_pyspark_type(values):
    from pyspark.sql import types as T
    for v in values:
        if v is None:
            continue
        if isinstance(v, bool):
            return T.BooleanType()
        if isinstance(v, int):
            return T.LongType()
        if isinstance(v, float):
            return T.DoubleType()
        return T.StringType()
    return T.StringType()


def build_dataframe(spark, columns: list, rows: list[dict]):
    from pyspark.sql import types as T
    col_types = {c: infer_pyspark_type([r.get(c) for r in rows]) for c in columns}
    # promote to float if any column has mixed int/float
    coerced_rows = []
    for r in rows:
        row = []
        for c in columns:
            v = r.get(c)
            if isinstance(col_types[c], T.DoubleType) and isinstance(v, int):
                v = float(v)
            row.append(v)
        coerced_rows.append(tuple(row))
    schema = T.StructType([T.StructField(c, col_types[c], True) for c in columns])
    return spark.createDataFrame(coerced_rows, schema=schema)


RESULT_NAMES = ["result", "result_df", "df_result", "output", "final_result", "answer"]


def verify_code(spark, question: str, code: str, source_name: str = "<generated>") -> str | None:
    """Execute `code` against sample DataFrames built from `question`. Return None on
    success, or an error string (crash / bad-generation) on failure."""
    tables = parse_tables(question)

    namespace = {"spark": spark}
    for tname, rows in tables.items():
        if not rows:
            continue
        columns = list(rows[0].keys())
        try:
            namespace[tname] = build_dataframe(spark, columns, rows)
        except Exception as e:
            return f"failed to build sample DataFrame for '{tname}': {e}"

    # strip a leading module docstring so exec() doesn't choke on anything odd in it
    clean_code = re.sub(r'^""".*?"""\s*', "", code, count=1, flags=re.DOTALL)

    try:
        exec(compile(clean_code, source_name, "exec"), namespace)
        for name in RESULT_NAMES:
            if name in namespace and hasattr(namespace[name], "collect"):
                namespace[name].collect()
                break
    except Exception:
        return traceback.format_exc(limit=3)
    return None


def run_one(spark, sql_path: str, py_path: str) -> str | None:
    """Return None on success, or an error string."""
    with open(sql_path, encoding="utf-8") as f:
        sql_content = f.read()
    m = re.search(r"/\*(.*?)\*/", sql_content, re.DOTALL)
    question = m.group(1) if m else ""
    with open(py_path, encoding="utf-8") as f:
        code = f.read()
    return verify_code(spark, question, code, source_name=py_path)


def main():
    delete_broken = "--delete-broken" in sys.argv

    from pyspark.sql import SparkSession
    spark = (
        SparkSession.builder.master("local[2]")
        .appName("verify_pyspark")
        .config("spark.ui.enabled", "false")
        .config("spark.sql.shuffle.partitions", "2")
        .getOrCreate()
    )
    spark.sparkContext.setLogLevel("ERROR")

    py_files = sorted(f for f in os.listdir(os.path.join(DD_DIR, "python")) if f.endswith(".py"))
    print(f"{len(py_files)} .py files to verify.\n")

    broken = []
    ok = 0
    for i, fname in enumerate(py_files, 1):
        py_path = os.path.join(DD_DIR, "python", fname)
        sql_path = os.path.join(DD_DIR, "sql", fname[:-3] + ".sql")
        if not os.path.exists(sql_path):
            print(f"[{i:04}/{len(py_files)}] SKIP {fname}: no matching .sql file")
            continue
        err = run_one(spark, sql_path, py_path)
        if err:
            print(f"[{i:04}/{len(py_files)}] BROKEN {fname}")
            print("  " + err.strip().replace("\n", "\n  "))
            broken.append(fname)
            if delete_broken:
                os.remove(py_path)
        else:
            ok += 1

    spark.stop()

    print(f"\nOK: {ok}  BROKEN: {len(broken)}")
    if broken:
        print("\nBroken files:")
        for f in broken:
            print(" ", f)


if __name__ == "__main__":
    main()
