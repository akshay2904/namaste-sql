"""
Monthly Active Users  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/monthly_active_users

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("monthly_active_users").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_activity_rows = [{"user_id": "1", "activity_date": "2024-01-05", "action": "login"}, {"user_id": "2", "activity_date": "2024-01-07", "action": "login"}, {"user_id": "3", "activity_date": "2024-01-10", "action": "purchase"}, {"user_id": "1", "activity_date": "2024-01-15", "action": "purchase"}, {"user_id": "4", "activity_date": "2024-01-20", "action": "login"}]
user_activity = _make_df(_user_activity_rows, ['user_id', 'activity_date', 'action']).select(
    F.col("user_id").cast("int").alias("user_id"),
    F.col("activity_date"),
    F.col("action")
)

df = user_activity  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("month", F.date_format(F.col("activity_date"), "yyyy-MM"))
    .groupBy("month")
    .agg(F.countDistinct("user_id").alias("active_users"))
    .orderBy("month")
)

result.show(truncate=False)

spark.stop()
