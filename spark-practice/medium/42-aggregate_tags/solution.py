"""
Aggregate Tags into Array  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/aggregate_tags

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("aggregate_tags").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_rows = [{"product_id": "1", "product_name": "Laptop", "tag": "electronics"}, {"product_id": "1", "product_name": "Laptop", "tag": "portable"}, {"product_id": "1", "product_name": "Laptop", "tag": "computing"}, {"product_id": "2", "product_name": "Headphones", "tag": "electronics"}, {"product_id": "2", "product_name": "Headphones", "tag": "audio"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'tag']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("tag")
)

df = products  # single input table also bound as df

# ---- solution ----
result = (
    df
    .groupBy("product_id", "product_name")
    .agg(F.array_join(F.array_sort(F.collect_list("tag")), ",").alias("tags"))
    .orderBy("product_id")
)

result.show(truncate=False)

spark.stop()
