"""
Slowly Changing Dimension Type 2  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/scd_type2_detection

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("scd_type2_detection").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_employee_history_rows = [{"record_id": "1", "employee_id": "101", "name": "Alice Chen", "department": "Engineering", "salary": "80000", "effective_date": "2022-01-01"}, {"record_id": "2", "employee_id": "101", "name": "Alice Chen", "department": "Engineering", "salary": "85000", "effective_date": "2022-07-01"}, {"record_id": "3", "employee_id": "101", "name": "Alice Chen", "department": "Data Science", "salary": "90000", "effective_date": "2023-01-01"}, {"record_id": "4", "employee_id": "102", "name": "Bob Kim", "department": "Marketing", "salary": "70000", "effective_date": "2022-03-01"}, {"record_id": "5", "employee_id": "102", "name": "Bob Kim", "department": "Marketing", "salary": "73000", "effective_date": "2022-09-01"}]
employee_history = _make_df(_employee_history_rows, ['record_id', 'employee_id', 'name', 'department', 'salary', 'effective_date']).select(
    F.col("record_id").cast("int").alias("record_id"),
    F.col("employee_id").cast("int").alias("employee_id"),
    F.col("name"),
    F.col("department"),
    F.col("salary").cast("int").alias("salary"),
    F.col("effective_date")
)

df = employee_history  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("employee_id").orderBy("effective_date")

result = (
    df
    .withColumn("end_date", F.lead("effective_date").over(w))
    .withColumn("is_current", F.when(F.col("end_date").isNull(), 1).otherwise(0))
    .select(
        "record_id",
        "employee_id",
        "name",
        "department",
        "salary",
        "effective_date",
        "end_date",
        "is_current",
    )
    .orderBy("employee_id", "effective_date")
)

result.show(truncate=False)

spark.stop()
