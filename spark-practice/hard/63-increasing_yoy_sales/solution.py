"""
Products with Increasing YoY Sales  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/increasing_yoy_sales

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("increasing_yoy_sales").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_product_sales_rows = [{"product_id": "1", "product_name": "Widget Alpha", "year": "2021", "total_sales": "10000"}, {"product_id": "1", "product_name": "Widget Alpha", "year": "2022", "total_sales": "12000"}, {"product_id": "1", "product_name": "Widget Alpha", "year": "2023", "total_sales": "14500"}, {"product_id": "1", "product_name": "Widget Alpha", "year": "2024", "total_sales": "17000"}, {"product_id": "2", "product_name": "Gadget Beta", "year": "2021", "total_sales": "8000"}]
product_sales = _make_df(_product_sales_rows, ['product_id', 'product_name', 'year', 'total_sales']).select(
    F.col("product_id").cast("int").alias("product_id"),
    F.col("product_name"),
    F.col("year").cast("int").alias("year"),
    F.col("total_sales").cast("int").alias("total_sales")
)

df = product_sales  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("product_id").orderBy("year")

result = (
    df
    .withColumn("prev_sales", F.lag("total_sales").over(w))
    .withColumn("yoy_growth", F.col("total_sales") - F.col("prev_sales"))
    .filter(F.col("prev_sales").isNotNull())
    .groupBy("product_id", "product_name")
    .agg(F.min("yoy_growth").alias("min_growth"))
    .filter(F.col("min_growth") > 0)
    .select("product_id", "product_name")
    .orderBy("product_id")
)

result.show(truncate=False)

spark.stop()
