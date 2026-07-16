"""
Top N with Tie-Breaking  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/top_n_tiebreak

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("top_n_tiebreak").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_employees_rows = [{"employee_id": "1", "name": "Alice", "department": "Engineering", "salary": "95000"}, {"employee_id": "2", "name": "Bob", "department": "Engineering", "salary": "88000"}, {"employee_id": "3", "name": "Carol", "department": "Engineering", "salary": "95000"}, {"employee_id": "4", "name": "Dave", "department": "Engineering", "salary": "72000"}, {"employee_id": "5", "name": "Eve", "department": "Marketing", "salary": "70000"}]
employees = _make_df(_employees_rows, ['employee_id', 'name', 'department', 'salary']).select(
    F.col("employee_id").cast("int").alias("employee_id"),
    F.col("name"),
    F.col("department"),
    F.col("salary").cast("int").alias("salary")
)

df = employees  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("department").orderBy(
    F.col("salary").desc(),
    F.col("employee_id").asc(),
)

result = (
    employees
    .withColumn("row_num", F.row_number().over(w))
    .filter(F.col("row_num") <= 2)
    .select("department", "employee_id", "name", "salary", "row_num")
    .orderBy("department", "row_num")
)

result.show()


spark.stop()
