"""
Funnel Analysis  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/funnel_analysis

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("funnel_analysis").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_events_rows = [{"event_id": "1", "user_id": "1", "event_type": "view", "event_date": "2024-01-01"}, {"event_id": "2", "user_id": "1", "event_type": "cart", "event_date": "2024-01-01"}, {"event_id": "3", "user_id": "1", "event_type": "checkout", "event_date": "2024-01-01"}, {"event_id": "4", "user_id": "1", "event_type": "purchase", "event_date": "2024-01-01"}, {"event_id": "5", "user_id": "2", "event_type": "view", "event_date": "2024-01-01"}]
user_events = _make_df(_user_events_rows, ['event_id', 'user_id', 'event_type', 'event_date']).select(
    F.col("event_id").cast("int").alias("event_id"),
    F.col("user_id").cast("int").alias("user_id"),
    F.col("event_type"),
    F.col("event_date")
)

df = user_events  # single input table also bound as df

# ---- solution ----
stage_order = {"view": 1, "cart": 2, "checkout": 3, "purchase": 4}

counts = (
    user_events
    .groupBy(F.col("event_type").alias("stage"))
    .agg(F.countDistinct("user_id").alias("users_reached"))
)

result = (
    counts
    .withColumn("stage_order",
        F.when(F.col("stage") == "view", 1)
         .when(F.col("stage") == "cart", 2)
         .when(F.col("stage") == "checkout", 3)
         .when(F.col("stage") == "purchase", 4)
    )
    .select("stage", "stage_order", "users_reached")
    .orderBy("stage_order")
)

result.show(truncate=False)

spark.stop()
