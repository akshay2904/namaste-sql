"""
Column Arithmetic  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/column_arithmetic

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("column_arithmetic").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_rows = [{"product_id": "1", "product_name": "Laptop", "price": "1200", "quantity": "5", "discount_pct": "10"}, {"product_id": "2", "product_name": "Phone", "price": "800", "quantity": "12", "discount_pct": "15"}, {"product_id": "3", "product_name": "Tablet", "price": "500", "quantity": "8", "discount_pct": "5"}, {"product_id": "4", "product_name": "Monitor", "price": "950", "quantity": "3", "discount_pct": "20"}, {"product_id": "5", "product_name": "Keyboard", "price": "120", "quantity": "25", "discount_pct": "0"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'price', 'quantity', 'discount_pct']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("price").cast("int").alias("price"),
    F.col("quantity").cast("int").alias("quantity"),
    F.col("discount_pct").cast("int").alias("discount_pct")
)

df = products  # single input table also bound as df

# ---- solution ----
discounted = F.round(F.col("price") * (1 - F.col("discount_pct") / 100.0), 2)

result = (
    df
    .withColumn("discounted_price", discounted)
    .withColumn("total_revenue", F.round(discounted * F.col("quantity"), 2))
    .select("product_id", "product_name", "discounted_price", "total_revenue")
    .orderBy(F.desc("total_revenue"))
)

result.show(truncate=False)

spark.stop()
