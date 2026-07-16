"""
Simple Inner Join  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/simple_inner_join

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("simple_inner_join").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "1", "amount": "500", "status": "completed"}, {"order_id": "2", "customer_id": "2", "amount": "800", "status": "completed"}, {"order_id": "3", "customer_id": "3", "amount": "300", "status": "pending"}, {"order_id": "4", "customer_id": "1", "amount": "650", "status": "completed"}, {"order_id": "5", "customer_id": "4", "amount": "900", "status": "completed"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'amount', 'status']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount"),
    F.col("status")
)

_customers_rows = [{"customer_id": "1", "name": "Alice", "city": "New York"}, {"customer_id": "2", "name": "Bob", "city": "London"}, {"customer_id": "3", "name": "Charlie", "city": "Paris"}, {"customer_id": "4", "name": "Diana", "city": "Berlin"}, {"customer_id": "5", "name": "Eve", "city": "Tokyo"}]
customers = _make_df(_customers_rows, ['customer_id', 'name', 'city']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("name"),
    F.col("city")
)

# ---- solution ----
# orders and customers are available as variables

result = (
    orders
    .filter(F.col("status") == "completed")
    .join(customers, on="customer_id")
    .select("order_id", "name", "city", "amount")
    .orderBy("order_id")
)

result.show(truncate=False)

spark.stop()
