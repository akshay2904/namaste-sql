"""
Count Distinct Users per Day  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/count_distinct_day

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("count_distinct_day").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_events_rows = [{"event_id": "1", "user_id": "101", "event_date": "2024-01-01", "event_type": "click"}, {"event_id": "2", "user_id": "102", "event_date": "2024-01-01", "event_type": "view"}, {"event_id": "3", "user_id": "101", "event_date": "2024-01-01", "event_type": "purchase"}, {"event_id": "4", "user_id": "103", "event_date": "2024-01-02", "event_type": "click"}, {"event_id": "5", "user_id": "101", "event_date": "2024-01-02", "event_type": "view"}]
user_events = _make_df(_user_events_rows, ['event_id', 'user_id', 'event_date', 'event_type']).select(
    F.col("event_id").cast("int").alias("event_id"),
    F.col("user_id").cast("int").alias("user_id"),
    F.col("event_date"),
    F.col("event_type")
)

df = user_events  # single input table also bound as df

# ---- solution ----
result = (
    df
    .groupBy("event_date")
    .agg(
        F.countDistinct("user_id").alias("distinct_users"),
        F.count("*").alias("total_events")
    )
    .orderBy("event_date")
)

result.show(truncate=False)

spark.stop()
