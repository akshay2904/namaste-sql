"""
Full Outer Join  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/full_outer_join

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("full_outer_join").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_employees_rows = [{"employee_id": "1", "name": "Alice", "department_id": "10"}, {"employee_id": "2", "name": "Bob", "department_id": "20"}, {"employee_id": "3", "name": "Charlie", "department_id": "10"}, {"employee_id": "4", "name": "Diana", "department_id": "30"}, {"employee_id": "5", "name": "Eve", "department_id": "40"}]
employees = _make_df(_employees_rows, ['employee_id', 'name', 'department_id']).select(
    F.col("employee_id").cast("int").alias("employee_id"),
    F.col("name"),
    F.col("department_id").cast("int").alias("department_id")
)

_departments_rows = [{"department_id": "10", "department_name": "Engineering", "budget": "500000"}, {"department_id": "20", "department_name": "Marketing", "budget": "300000"}, {"department_id": "50", "department_name": "Finance", "budget": "400000"}, {"department_id": "60", "department_name": "HR", "budget": "200000"}]
departments = _make_df(_departments_rows, ['department_id', 'department_name', 'budget']).select(
    F.col("department_id").cast("int").alias("department_id"),
    F.col("department_name"),
    F.col("budget").cast("int").alias("budget")
)

# ---- solution ----
# employees and departments are available as variables

result = (
    employees
    .join(departments, on="department_id", how="outer")
    .withColumn("department_id", F.coalesce(
        employees["department_id"], departments["department_id"]
    ))
    .select("employee_id", "name", "department_id", "department_name", "budget")
    .orderBy(F.asc_nulls_last("department_id"), F.asc_nulls_last("employee_id"))
)

result.show(truncate=False)

spark.stop()
