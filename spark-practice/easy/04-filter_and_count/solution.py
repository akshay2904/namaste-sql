"""
Filter and Count  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/filter_and_count

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("filter_and_count").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "1", "product": "Laptop", "country": "USA", "amount": "1200"}, {"order_id": "2", "customer_id": "2", "product": "Phone", "country": "UK", "amount": "800"}, {"order_id": "3", "customer_id": "1", "product": "Tablet", "country": "USA", "amount": "500"}, {"order_id": "4", "customer_id": "3", "product": "Laptop", "country": "Canada", "amount": "1200"}, {"order_id": "5", "customer_id": "2", "product": "Laptop", "country": "UK", "amount": "1200"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'product', 'country', 'amount']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("product"),
    F.col("country"),
    F.col("amount").cast("int").alias("amount")
)

df = orders  # single input table also bound as df

# ---- solution ----
result = (
    df
    .filter(F.col("country") == "USA")
    .groupBy("country")
    .agg(
        F.countDistinct("customer_id").alias("distinct_customers"),
        F.sum("amount").alias("total_revenue")
    )
)

result.show(truncate=False)

spark.stop()
