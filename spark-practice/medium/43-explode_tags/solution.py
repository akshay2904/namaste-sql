"""
Explode Tags to Rows  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/explode_tags

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("explode_tags").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_with_arrays_rows = [{"product_id": "1", "product_name": "Laptop", "tags": "electronics,portable,computing"}, {"product_id": "2", "product_name": "Headphones", "tags": "electronics,audio,wireless"}, {"product_id": "3", "product_name": "Running Shoes", "tags": "footwear,sports,outdoor"}, {"product_id": "4", "product_name": "Coffee Maker", "tags": "kitchen,appliance"}, {"product_id": "5", "product_name": "Yoga Mat", "tags": "sports,fitness,outdoor"}]
products_with_arrays = _make_df(_products_with_arrays_rows, ['product_id', 'product_name', 'tags']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("tags")
)

df = products_with_arrays  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("tag", F.explode(F.split(F.col("tags"), ",")))
    .select("product_id", "product_name", "tag")
    .orderBy("product_id", "tag")
)

result.show(truncate=False)

spark.stop()
