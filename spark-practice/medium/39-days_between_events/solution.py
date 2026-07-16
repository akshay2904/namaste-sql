"""
Days Between Events  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/days_between_events

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("days_between_events").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_events_rows = [{"event_id": "1", "user_id": "101", "event_type": "signup", "event_date": "2024-01-05"}, {"event_id": "2", "user_id": "101", "event_type": "first_purchase", "event_date": "2024-01-19"}, {"event_id": "3", "user_id": "102", "event_type": "signup", "event_date": "2024-01-10"}, {"event_id": "4", "user_id": "102", "event_type": "first_purchase", "event_date": "2024-02-01"}, {"event_id": "5", "user_id": "103", "event_type": "signup", "event_date": "2024-02-03"}]
user_events = _make_df(_user_events_rows, ['event_id', 'user_id', 'event_type', 'event_date']).select(
    F.col("event_id").cast("int").alias("event_id"),
    F.col("user_id").cast("int").alias("user_id"),
    F.col("event_type"),
    F.col("event_date")
)

df = user_events  # single input table also bound as df

# ---- solution ----
pivoted = (
    df
    .groupBy("user_id")
    .agg(
        F.max(F.when(F.col("event_type") == "signup", F.col("event_date"))).alias("signup_date"),
        F.max(F.when(F.col("event_type") == "first_purchase", F.col("event_date"))).alias("first_purchase_date"),
    )
)

result = (
    pivoted
    .withColumn("days_to_purchase", F.datediff(F.col("first_purchase_date"), F.col("signup_date")))
    .select("user_id", "signup_date", "first_purchase_date", "days_to_purchase")
    .orderBy("user_id")
)

result.show(truncate=False)

spark.stop()
