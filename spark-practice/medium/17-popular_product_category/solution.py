"""
Most Popular Product per Category  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/popular_product_category

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("popular_product_category").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_rows = [{"product_id": "1", "product_name": "Laptop Pro", "category": "Electronics"}, {"product_id": "2", "product_name": "Wireless Mouse", "category": "Electronics"}, {"product_id": "3", "product_name": "Standing Desk", "category": "Furniture"}, {"product_id": "4", "product_name": "USB Hub", "category": "Electronics"}, {"product_id": "5", "product_name": "Office Chair", "category": "Furniture"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'category']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("category")
)

_sales_rows = [{"sale_id": "1", "product_id": "1", "quantity": "5"}, {"sale_id": "2", "product_id": "2", "quantity": "12"}, {"sale_id": "3", "product_id": "3", "quantity": "3"}, {"sale_id": "4", "product_id": "4", "quantity": "8"}, {"sale_id": "5", "product_id": "5", "quantity": "6"}]
sales = _make_df(_sales_rows, ['sale_id', 'product_id', 'quantity']).select(
    F.col("sale_id").cast("int").alias("sale_id"),
    F.col("product_id").cast("int").alias("product_id"),
    F.col("quantity").cast("int").alias("quantity")
)

# ---- solution ----
# products and sales are available as variables

window = Window.partitionBy("category").orderBy(F.desc("total_quantity"))

result = (
    products
    .join(sales, on="product_id")
    .groupBy("category", "product_name")
    .agg(F.sum("quantity").alias("total_quantity"))
    .withColumn("rank", F.rank().over(window))
    .filter(F.col("rank") == 1)
    .select("category", "product_name", "total_quantity")
    .orderBy("category")
)

result.show(truncate=False)

spark.stop()
