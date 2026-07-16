"""
Pivot Attendance by Status  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/pivot_attendance

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("pivot_attendance").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_attendance_rows = [{"employee_id": "1", "attendance_date": "2024-01-01", "status": "Present"}, {"employee_id": "1", "attendance_date": "2024-01-02", "status": "Present"}, {"employee_id": "1", "attendance_date": "2024-01-03", "status": "Late"}, {"employee_id": "1", "attendance_date": "2024-01-04", "status": "Absent"}, {"employee_id": "2", "attendance_date": "2024-01-01", "status": "Absent"}]
attendance = _make_df(_attendance_rows, ['employee_id', 'attendance_date', 'status']).select(
    F.col("employee_id").cast("int").alias("employee_id"),
    F.col("attendance_date"),
    F.col("status")
)

df = attendance  # single input table also bound as df

# ---- solution ----
result = (
    df
    .groupBy("employee_id")
    .pivot("status", ["Present", "Absent", "Late"])
    .count()
    .orderBy("employee_id")
)

result.show(truncate=False)

spark.stop()
