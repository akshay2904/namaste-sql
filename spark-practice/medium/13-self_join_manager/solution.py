"""
Self Join — Find Manager  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/self_join_manager

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("self_join_manager").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_employees_rows = [{"employee_id": "1", "name": "Alice", "department": "Engineering", "manager_id": ""}, {"employee_id": "2", "name": "Bob", "department": "Engineering", "manager_id": "1"}, {"employee_id": "3", "name": "Charlie", "department": "Engineering", "manager_id": "1"}, {"employee_id": "4", "name": "Diana", "department": "Marketing", "manager_id": ""}, {"employee_id": "5", "name": "Eve", "department": "Marketing", "manager_id": "4"}]
employees = _make_df(_employees_rows, ['employee_id', 'name', 'department', 'manager_id']).select(
    F.col("employee_id").cast("int").alias("employee_id"),
    F.col("name"),
    F.col("department"),
    F.col("manager_id").cast("int").alias("manager_id")
)

df = employees  # single input table also bound as df

# ---- solution ----
managers = df.select(
    F.col("employee_id").alias("manager_id"),
    F.col("name").alias("manager_name")
)

result = (
    df
    .join(managers, on="manager_id", how="left")
    .select("employee_id", "name", "department", "manager_name")
    .orderBy("employee_id")
)

result.show(truncate=False)

spark.stop()
