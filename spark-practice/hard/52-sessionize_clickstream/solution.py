"""
Sessionize Clickstream Data  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/sessionize_clickstream

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("sessionize_clickstream").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_clickstream_rows = [{"event_id": "1", "user_id": "1", "page": "home", "event_time": "2024-01-01 10:00:00"}, {"event_id": "2", "user_id": "1", "page": "products", "event_time": "2024-01-01 10:10:00"}, {"event_id": "3", "user_id": "1", "page": "product_detail", "event_time": "2024-01-01 10:20:00"}, {"event_id": "4", "user_id": "1", "page": "cart", "event_time": "2024-01-01 11:05:00"}, {"event_id": "5", "user_id": "1", "page": "checkout", "event_time": "2024-01-01 11:15:00"}]
clickstream = _make_df(_clickstream_rows, ['event_id', 'user_id', 'page', 'event_time']).select(
    F.col("event_id").cast("int").alias("event_id"),
    F.col("user_id").cast("int").alias("user_id"),
    F.col("page"),
    F.col("event_time")
)

df = clickstream  # single input table also bound as df

# ---- solution ----
# Window for LAG and running SUM — ordered by event_time within each user
w = Window.partitionBy("user_id").orderBy("event_time")
w_running = Window.partitionBy("user_id").orderBy("event_time").rowsBetween(
    Window.unboundedPreceding, Window.currentRow
)

result = (
    clickstream
    .withColumn("prev_time", F.lag("event_time", 1).over(w))
    .withColumn(
        "gap_secs",
        F.unix_timestamp("event_time") - F.unix_timestamp("prev_time")
    )
    .withColumn(
        "new_flag",
        F.when(
            F.col("prev_time").isNull() | (F.col("gap_secs") > 1800), 1
        ).otherwise(0)
    )
    .withColumn("session_id", F.sum("new_flag").over(w_running))
    .select("event_id", "user_id", "page", "event_time", "session_id")
    .orderBy("user_id", "event_time")
)

result.show()


spark.stop()
