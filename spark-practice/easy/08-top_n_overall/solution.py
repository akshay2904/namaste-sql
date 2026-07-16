"""
Top N Overall  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/top_n_overall

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("top_n_overall").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_products_rows = [{"product_id": "1", "product_name": "Laptop Pro", "category": "Electronics", "total_sales": "45000"}, {"product_id": "2", "product_name": "Wireless Mouse", "category": "Electronics", "total_sales": "8500"}, {"product_id": "3", "product_name": "Standing Desk", "category": "Furniture", "total_sales": "32000"}, {"product_id": "4", "product_name": "USB Hub", "category": "Electronics", "total_sales": "4200"}, {"product_id": "5", "product_name": "Office Chair", "category": "Furniture", "total_sales": "28000"}]
products = _make_df(_products_rows, ['product_id', 'product_name', 'category', 'total_sales']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("category"),
    F.col("total_sales").cast("int").alias("total_sales")
)

df = products  # single input table also bound as df

# ---- solution ----
result = (
    df
    .orderBy(F.desc("total_sales"))
    .limit(5)
    .select("product_id", "product_name", "category", "total_sales")
)

result.show(truncate=False)

spark.stop()
