"""
Unsold Products  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/unsold_products

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("unsold_products").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_rows = [{"product_id": "1", "product_name": "Laptop", "category": "Electronics", "price": "1200"}, {"product_id": "2", "product_name": "Phone", "category": "Electronics", "price": "800"}, {"product_id": "3", "product_name": "Tablet", "category": "Electronics", "price": "500"}, {"product_id": "4", "product_name": "Monitor", "category": "Electronics", "price": "950"}, {"product_id": "5", "product_name": "Keyboard", "category": "Accessories", "price": "120"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'category', 'price']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("category"),
    F.col("price").cast("int").alias("price")
)

_sales_rows = [{"sale_id": "1", "product_id": "1", "quantity": "2", "sale_date": "2024-01-01"}, {"sale_id": "2", "product_id": "2", "quantity": "5", "sale_date": "2024-01-02"}, {"sale_id": "3", "product_id": "3", "quantity": "1", "sale_date": "2024-01-03"}, {"sale_id": "4", "product_id": "1", "quantity": "3", "sale_date": "2024-01-04"}, {"sale_id": "5", "product_id": "5", "quantity": "10", "sale_date": "2024-01-05"}]
sales = _make_df(_sales_rows, ['sale_id', 'product_id', 'quantity', 'sale_date']).select(
    F.col("sale_id").cast("int").alias("sale_id"),
    F.col("product_id").cast("int").alias("product_id"),
    F.col("quantity").cast("int").alias("quantity"),
    F.col("sale_date")
)

# ---- solution ----
# products and sales are available as variables

result = (
    products
    .join(sales, on="product_id", how="left_anti")
    .select("product_id", "product_name", "category", "price")
    .orderBy("product_id")
)

result.show(truncate=False)

spark.stop()
