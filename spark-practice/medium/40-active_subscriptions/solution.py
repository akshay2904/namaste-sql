"""
Active Subscriptions on a Date  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/active_subscriptions

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("active_subscriptions").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_subscriptions_rows = [{"sub_id": "1", "customer_id": "201", "start_date": "2024-01-01", "end_date": "2024-12-31", "plan": "annual"}, {"sub_id": "2", "customer_id": "202", "start_date": "2024-03-15", "end_date": "2024-09-14", "plan": "semi-annual"}, {"sub_id": "3", "customer_id": "203", "start_date": "2024-05-01", "end_date": "2024-07-31", "plan": "quarterly"}, {"sub_id": "4", "customer_id": "204", "start_date": "2024-06-01", "end_date": "2024-08-31", "plan": "quarterly"}, {"sub_id": "5", "customer_id": "205", "start_date": "2024-06-15", "end_date": "2024-09-15", "plan": "quarterly"}]
subscriptions = _make_df(_subscriptions_rows, ['sub_id', 'customer_id', 'start_date', 'end_date', 'plan']).select(
    F.col("sub_id").cast("int").alias("sub_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("start_date"),
    F.col("end_date"),
    F.col("plan")
)

df = subscriptions  # single input table also bound as df

# ---- solution ----
target_date = "2024-06-15"

result = (
    df
    .filter(
        (F.col("start_date") <= target_date) &
        (F.col("end_date") >= target_date)
    )
    .select("sub_id", "customer_id", "plan", "start_date", "end_date")
    .orderBy("sub_id")
)

result.show(truncate=False)

spark.stop()
