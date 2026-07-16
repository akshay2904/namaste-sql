"""
Late Deliveries  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/late_deliveries

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("late_deliveries").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "301", "order_date": "2024-01-05", "delivery_date": "2024-01-08", "promised_days": "5"}, {"order_id": "2", "customer_id": "302", "order_date": "2024-01-07", "delivery_date": "2024-01-15", "promised_days": "5"}, {"order_id": "3", "customer_id": "303", "order_date": "2024-01-10", "delivery_date": "2024-01-13", "promised_days": "3"}, {"order_id": "4", "customer_id": "304", "order_date": "2024-01-12", "delivery_date": "2024-01-20", "promised_days": "5"}, {"order_id": "5", "customer_id": "305", "order_date": "2024-01-15", "delivery_date": "2024-01-17", "promised_days": "3"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'order_date', 'delivery_date', 'promised_days']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("order_date"),
    F.col("delivery_date"),
    F.col("promised_days").cast("int").alias("promised_days")
)

df = orders  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("actual_days", F.datediff(F.col("delivery_date"), F.col("order_date")))
    .withColumn("days_late", F.col("actual_days") - F.col("promised_days"))
    .filter(F.col("actual_days") > F.col("promised_days"))
    .select("order_id", "customer_id", "promised_days", "actual_days", "days_late")
    .orderBy(F.col("days_late").desc())
)

result.show(truncate=False)

spark.stop()
