"""
Multi-Table Join  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/multi_table_join

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("multi_table_join").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "1", "product_id": "101", "quantity": "2"}, {"order_id": "2", "customer_id": "1", "product_id": "102", "quantity": "1"}, {"order_id": "3", "customer_id": "2", "product_id": "101", "quantity": "3"}, {"order_id": "4", "customer_id": "3", "product_id": "103", "quantity": "1"}, {"order_id": "5", "customer_id": "2", "product_id": "103", "quantity": "2"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'product_id', 'quantity']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("product_id").cast("int").alias("product_id"),
    F.col("quantity").cast("int").alias("quantity")
)

_customers_rows = [{"customer_id": "1", "name": "Alice", "city": "New York"}, {"customer_id": "2", "name": "Bob", "city": "San Francisco"}, {"customer_id": "3", "name": "Charlie", "city": "Chicago"}, {"customer_id": "4", "name": "Diana", "city": "New York"}]
customers = _make_df(_customers_rows, ['customer_id', 'name', 'city']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("name"),
    F.col("city")
)

_products_rows = [{"product_id": "101", "product_name": "Laptop", "price": "1200"}, {"product_id": "102", "product_name": "Phone", "price": "800"}, {"product_id": "103", "product_name": "Tablet", "price": "500"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'price']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("price").cast("int").alias("price")
)

# ---- solution ----
# All tables are available as variables: orders, customers, products

result = (
    orders
    .join(customers, on="customer_id")
    .join(products, on="product_id")
    .withColumn("revenue", F.col("quantity") * F.col("price"))
    .groupBy("customer_id", "name", "city")
    .agg(F.sum("revenue").alias("total_revenue"))
    .orderBy(F.desc("total_revenue"))
)

result.show(truncate=False)

spark.stop()
