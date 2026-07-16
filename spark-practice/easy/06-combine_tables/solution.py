"""
Combine Two Tables  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/combine_tables

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("combine_tables").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_2023_rows = [{"order_id": "1", "customer_id": "101", "amount": "500", "year": "2023"}, {"order_id": "2", "customer_id": "102", "amount": "800", "year": "2023"}, {"order_id": "3", "customer_id": "103", "amount": "300", "year": "2023"}, {"order_id": "4", "customer_id": "101", "amount": "650", "year": "2023"}]
orders_2023 = _make_df(_orders_2023_rows, ['order_id', 'customer_id', 'amount', 'year']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount"),
    F.col("year").cast("int").alias("year")
)

_orders_2024_rows = [{"order_id": "5", "customer_id": "102", "amount": "900", "year": "2024"}, {"order_id": "6", "customer_id": "104", "amount": "450", "year": "2024"}, {"order_id": "7", "customer_id": "101", "amount": "700", "year": "2024"}, {"order_id": "8", "customer_id": "105", "amount": "1200", "year": "2024"}]
orders_2024 = _make_df(_orders_2024_rows, ['order_id', 'customer_id', 'amount', 'year']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount"),
    F.col("year").cast("int").alias("year")
)

# ---- solution ----
# orders_2023 and orders_2024 are available as variables

result = (
    orders_2023
    .unionByName(orders_2024)
    .orderBy("order_id")
)

result.show(truncate=False)

spark.stop()
