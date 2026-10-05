"""
Generate a PySpark DataFrame-API solution for every Medium/Hard datadriven/*.sql
problem, using whichever free LLM provider keys you have as the backend.

Setup:
    Put one or more keys in a file named `.llm_keys` next to this script,
    one per line, formatted as:
        provider:key
        provider:key:model_override
    where provider is one of: kimi, gemini, nvidia
    Blank lines / lines starting with # are ignored. All valid keys are
    round-robined across requests (mixing providers spreads out rate limits
    and gives resilience if one provider is down).

Usage:
    python solve_pyspark.py                # all Medium/Hard problems
    python solve_pyspark.py --resume       # skip problems that already have a .py file
    python solve_pyspark.py --workers 3
"""
import argparse
import itertools
import json
import os
import re
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

from openai import OpenAI

import verify_pyspark

BASE_DIR = os.path.dirname(__file__)
DD_DIR = os.path.join(BASE_DIR, "datadriven")
META_FILE = os.path.join(DD_DIR, "_problems.json")
KEY_FILE = os.path.join(BASE_DIR, ".llm_keys")

PROVIDERS = {
    "kimi": {
        "base_url": "https://api.moonshot.ai/v1",
        "default_model": "kimi-k2-0711-preview",
    },
    "gemini": {
        "base_url": "https://generativelanguage.googleapis.com/v1beta/openai/",
        "default_model": "gemini-3.6-flash",
    },
    "nvidia": {
        "base_url": "https://integrate.api.nvidia.com/v1",
        "default_model": "nvidia/llama-3.3-nemotron-super-49b-v1",
    },
}

SYSTEM_PROMPT = """\
You are an expert PySpark developer. You will be given a SQL problem \
statement, its table schemas, and a correct SQL solution. Translate the SQL \
solution into an equivalent PySpark DataFrame-API solution.

Rules:
- Assume each table already exists as a DataFrame variable with the same \
  name as the table (e.g. table `svc_health` -> DataFrame `svc_health`).
- Use the DataFrame API (select, groupBy, agg, Window, join, ...), not \
  spark.sql() with a raw SQL string.
- Output ONLY Python code, no markdown fences, no prose explanation.
- Add brief inline comments only where the logic is non-obvious.
- Necessary imports (pyspark.sql.functions as F, Window, etc.) must be included.
"""


def load_key_lines() -> list[tuple[str, str, str | None]]:
    """Return [(provider, key, model_override_or_None), ...]."""
    if not os.path.exists(KEY_FILE):
        sys.exit(f"No key file found at {KEY_FILE}\nSee the docstring at the top of this script for the format.")
    entries = []
    with open(KEY_FILE, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split(":", 2)
            if len(parts) < 2:
                print(f"  skipping malformed line: {line!r}")
                continue
            provider = parts[0].strip().lower()
            key = parts[1].strip().strip("'\"")
            model = parts[2].strip().strip("'\"") if len(parts) == 3 and parts[2].strip() else None
            if provider not in PROVIDERS:
                print(f"  skipping unknown provider {provider!r} (known: {', '.join(PROVIDERS)})")
                continue
            entries.append((provider, key, model))
    if not entries:
        sys.exit(f"{KEY_FILE} exists but has no usable key lines in it.")
    return entries


def extract_question(content: str) -> str:
    m = re.search(r"/\*(.*?)\*/", content, re.DOTALL)
    return m.group(1).strip() if m else ""


def extract_sql_solution(content: str) -> str:
    marker = "-- Write your SQL solution below:"
    idx = content.find(marker)
    if idx == -1:
        return ""
    return content[idx + len(marker):].strip()


def py_filename(sql_filename: str) -> str:
    return sql_filename[:-4] + ".py" if sql_filename.endswith(".sql") else sql_filename + ".py"


def build_prompt(question: str, sql_solution: str, prev_code: str = None, prev_error: str = None) -> str:
    prompt = f"Problem + schema:\n{question}\n\nSQL solution:\n{sql_solution}"
    if prev_code and prev_error:
        prompt += (
            f"\n\nYour previous attempt crashed when run against sample data:\n"
            f"{prev_code}\n\nError:\n{prev_error}\n\nFix it and output the corrected code."
        )
    return prompt


class KeyPool:
    """Round-robins across (client, model) pairs, one per validated key."""

    def __init__(self, entries: list[tuple[str, str, str | None]]):
        self.slots = []
        for provider, key, model_override in entries:
            cfg = PROVIDERS[provider]
            model = model_override or cfg["default_model"]
            client = OpenAI(base_url=cfg["base_url"], api_key=key, timeout=60)
            try:
                client.chat.completions.create(
                    model=model,
                    max_tokens=5,
                    messages=[{"role": "user", "content": "Say OK."}],
                )
            except Exception as e:
                print(f"  DROPPING {provider} (model={model}): {e}")
                continue
            print(f"  OK {provider} (model={model})")
            self.slots.append((client, model))
        if not self.slots:
            sys.exit("No working keys — every provider failed the startup check.")
        self._cycle = itertools.cycle(self.slots)

    def next(self) -> tuple[OpenAI, str]:
        return next(self._cycle)


def solve_one(pool: KeyPool, question: str, sql_solution: str, prev_code: str = None, prev_error: str = None) -> str:
    client, model = pool.next()
    resp = client.chat.completions.create(
        model=model,
        max_tokens=1500,
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": build_prompt(question, sql_solution, prev_code, prev_error)},
        ],
    )
    text = resp.choices[0].message.content.strip()
    text = re.sub(r"^```(?:python)?\s*", "", text)
    text = re.sub(r"```\s*$", "", text)
    return text.strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--resume", action="store_true", help="skip problems that already have a .py file")
    ap.add_argument("--workers", type=int, default=4)
    ap.add_argument("--difficulty", default="Medium,Hard", help="comma-separated difficulties to include")
    ap.add_argument("--fix-attempts", type=int, default=2, help="retries with error feedback if generated code crashes")
    args = ap.parse_args()

    print("Validating keys...")
    entries = load_key_lines()
    pool = KeyPool(entries)
    print(f"\n{len(pool.slots)}/{len(entries)} key(s) usable.\n")

    os.environ.setdefault("JAVA_HOME", r"C:\Users\aksha\.jdk\jdk-17.0.20+8")
    from pyspark.sql import SparkSession
    spark = (
        SparkSession.builder.master("local[4]")
        .appName("solve_pyspark_verify")
        .config("spark.ui.enabled", "false")
        .config("spark.sql.shuffle.partitions", "2")
        .getOrCreate()
    )
    spark.sparkContext.setLogLevel("ERROR")

    with open(META_FILE, encoding="utf-8") as f:
        meta = json.load(f)

    difficulties = {d.strip() for d in args.difficulty.split(",")}
    targets = [m for m in meta if m["difficulty"] in difficulties]
    print(f"{len(targets)} problems match difficulty filter {sorted(difficulties)}.")

    pending = []
    for m in targets:
        sql_path = os.path.join(DD_DIR, "sql", m["filename"])
        py_path = os.path.join(DD_DIR, "python", py_filename(m["filename"]))
        if args.resume and os.path.exists(py_path):
            continue
        if not os.path.exists(sql_path):
            print(f"  MISSING SQL FILE: {m['filename']}")
            continue
        pending.append((m, sql_path, py_path))

    print(f"{len(pending)} to solve ({len(targets) - len(pending)} skipped).\n")
    if not pending:
        return

    def _generate(question, sql_solution, prev_code=None, prev_error=None):
        for attempt in range(3):
            try:
                return solve_one(pool, question, sql_solution, prev_code, prev_error)
            except Exception as e:
                if attempt < 2:
                    time.sleep(15 * (attempt + 1))
                else:
                    raise

    def _work(item):
        m, sql_path, py_path = item
        with open(sql_path, encoding="utf-8") as f:
            content = f.read()
        question = extract_question(content)
        sql_solution = extract_sql_solution(content)
        if not question or not sql_solution:
            return m["title"], None, "no question/solution to translate"

        code = prev_error = None
        for fix_round in range(args.fix_attempts + 1):
            try:
                code = _generate(question, sql_solution, code, prev_error)
            except Exception as e:
                return m["title"], None, f"API error: {e}"
            crash = verify_pyspark.verify_code(spark, question, code, source_name=py_path)
            if crash is None:
                return m["title"], (py_path, code), None
            prev_error = crash
        return m["title"], None, f"still crashes after {args.fix_attempts} fix attempt(s):\n{prev_error}"

    done = solved = errors = 0
    with ThreadPoolExecutor(max_workers=args.workers) as ex:
        futures = {ex.submit(_work, item): item for item in pending}
        for fut in as_completed(futures):
            title, result, err = fut.result()
            done += 1
            if err:
                print(f"  [{done:04}/{len(pending)}] ERROR {title}: {err}")
                errors += 1
                continue
            py_path, code = result
            header = f'"""PySpark solution for: {title}\nAuto-translated from the SQL solution in the matching .sql file."""\n\n'
            with open(py_path, "w", encoding="utf-8") as f:
                f.write(header + code + "\n")
            print(f"  [{done:04}/{len(pending)}] OK {title}")
            solved += 1

    spark.stop()
    print(f"\nSolved: {solved}  Errors: {errors}")


if __name__ == "__main__":
    main()
