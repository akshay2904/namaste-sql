"""
Parse JSON Column  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/parse_json_column

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("parse_json_column").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_events_rows = [{"event_id": "1", "user_id": "101", "event_type": "page_view", "properties": "{\"page\":\"home\",\"duration\":30,\"referrer\":\"google\"}"}, {"event_id": "2", "user_id": "102", "event_type": "page_view", "properties": "{\"page\":\"about\",\"duration\":15,\"referrer\":\"direct\"}"}, {"event_id": "3", "user_id": "101", "event_type": "click", "properties": "{\"page\":\"home\",\"duration\":5,\"referrer\":\"google\"}"}, {"event_id": "4", "user_id": "103", "event_type": "page_view", "properties": "{\"page\":\"pricing\",\"duration\":45,\"referrer\":\"twitter\"}"}, {"event_id": "5", "user_id": "102", "event_type": "purchase", "properties": "{\"page\":\"checkout\",\"duration\":120,\"referrer\":\"email\"}"}]
events = _make_df(_events_rows, ['event_id', 'user_id', 'event_type', 'properties']).select(
    F.col("event_id").cast("int").alias("event_id"),
    F.col("user_id").cast("int").alias("user_id"),
    F.col("event_type"),
    F.col("properties")
)

df = events  # single input table also bound as df

# ---- solution ----
json_schema = "struct<page:string,duration:string,referrer:string>"

result = (
    df
    .withColumn("parsed", F.from_json(F.col("properties"), json_schema))
    .select(
        "event_id", "user_id", "event_type",
        F.col("parsed.page").alias("page"),
        F.col("parsed.duration").alias("duration"),
        F.col("parsed.referrer").alias("referrer"),
    )
    .orderBy("event_id")
)

result.show(truncate=False)

spark.stop()
