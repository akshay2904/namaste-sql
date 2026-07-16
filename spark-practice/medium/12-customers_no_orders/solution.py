"""
Customers with No Orders  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/customers_no_orders

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("customers_no_orders").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_customers_rows = [{"customer_id": "1", "name": "Alice", "city": "New York", "signup_date": "2023-01-15"}, {"customer_id": "2", "name": "Bob", "city": "London", "signup_date": "2023-02-20"}, {"customer_id": "3", "name": "Charlie", "city": "Paris", "signup_date": "2023-03-10"}, {"customer_id": "4", "name": "Diana", "city": "Berlin", "signup_date": "2023-04-05"}, {"customer_id": "5", "name": "Eve", "city": "Tokyo", "signup_date": "2023-05-12"}]
customers = _make_df(_customers_rows, ['customer_id', 'name', 'city', 'signup_date']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("name"),
    F.col("city"),
    F.col("signup_date")
)

_orders_rows = [{"order_id": "1", "customer_id": "1", "amount": "500"}, {"order_id": "2", "customer_id": "2", "amount": "800"}, {"order_id": "3", "customer_id": "1", "amount": "300"}, {"order_id": "4", "customer_id": "3", "amount": "650"}, {"order_id": "5", "customer_id": "2", "amount": "900"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'amount']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount")
)

# ---- solution ----
# customers and orders are available as variables

result = (
    customers
    .join(orders, on="customer_id", how="left")
    .filter(F.col("order_id").isNull())
    .select("customer_id", "name", "city", "signup_date")
    .orderBy("customer_id")
)

result.show(truncate=False)

spark.stop()
