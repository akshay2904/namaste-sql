"""
Employee Salary vs Department Average  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/salary_vs_dept_avg

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("salary_vs_dept_avg").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_employees_rows = [{"employee_id": "1", "name": "Alice", "department": "Engineering", "salary": "95000"}, {"employee_id": "2", "name": "Bob", "department": "Engineering", "salary": "85000"}, {"employee_id": "3", "name": "Carol", "department": "Engineering", "salary": "105000"}, {"employee_id": "4", "name": "Dave", "department": "Marketing", "salary": "72000"}, {"employee_id": "5", "name": "Eve", "department": "Marketing", "salary": "68000"}]
employees = _make_df(_employees_rows, ['employee_id', 'name', 'department', 'salary']).select(
    F.col("employee_id").cast("int").alias("employee_id"),
    F.col("name"),
    F.col("department"),
    F.col("salary").cast("int").alias("salary")
)

df = employees  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("department")

result = (
    df
    .withColumn("dept_avg_salary", F.round(F.avg("salary").over(w), 2))
    .withColumn("diff_from_avg", F.round(F.col("salary") - F.avg("salary").over(w), 2))
    .select("employee_id", "name", "department", "salary", "dept_avg_salary", "diff_from_avg")
    .orderBy("department", "employee_id")
)

result.show(truncate=False)

spark.stop()
