"""
Categorize by Price  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/categorize_by_price

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("categorize_by_price").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_rows = [{"product_id": "1", "product_name": "Laptop Pro", "category": "Electronics", "price": "2500"}, {"product_id": "2", "product_name": "Wireless Mouse", "category": "Electronics", "price": "35"}, {"product_id": "3", "product_name": "Standing Desk", "category": "Furniture", "price": "850"}, {"product_id": "4", "product_name": "USB Hub", "category": "Electronics", "price": "45"}, {"product_id": "5", "product_name": "Office Chair", "category": "Furniture", "price": "420"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'category', 'price']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("category"),
    F.col("price").cast("int").alias("price")
)

df = products  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("price_tier",
        F.when(F.col("price") < 50, "Budget")
         .when(F.col("price") < 500, "Mid-range")
         .otherwise("Premium")
    )
    .select("product_id", "product_name", "price", "price_tier")
    .orderBy("price")
)

result.show(truncate=False)

spark.stop()
