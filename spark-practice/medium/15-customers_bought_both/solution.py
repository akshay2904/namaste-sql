"""
Customers Who Bought Both  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/customers_bought_both

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("customers_bought_both").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "1", "product": "Laptop"}, {"order_id": "2", "customer_id": "2", "product": "Phone"}, {"order_id": "3", "customer_id": "1", "product": "Phone"}, {"order_id": "4", "customer_id": "3", "product": "Laptop"}, {"order_id": "5", "customer_id": "4", "product": "Phone"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'product']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("product")
)

df = orders  # single input table also bound as df

# ---- solution ----
laptop_buyers = df.filter(F.col("product") == "Laptop").select("customer_id")
phone_buyers = df.filter(F.col("product") == "Phone").select("customer_id")

result = laptop_buyers.intersect(phone_buyers).orderBy("customer_id")

result.show(truncate=False)

spark.stop()
