"""
Merge Arrays Across Rows  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/merge_arrays

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("merge_arrays").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_purchases_rows = [{"user_id": "1", "purchase_date": "2024-01-05", "items": "laptop,mouse,keyboard"}, {"user_id": "1", "purchase_date": "2024-01-20", "items": "monitor,keyboard"}, {"user_id": "2", "purchase_date": "2024-01-08", "items": "phone,case"}, {"user_id": "2", "purchase_date": "2024-01-15", "items": "earbuds,phone,charger"}, {"user_id": "3", "purchase_date": "2024-01-03", "items": "tablet,stylus"}]
user_purchases = _make_df(_user_purchases_rows, ['user_id', 'purchase_date', 'items']).select(
    F.col("user_id").cast("int").alias("user_id"),
    F.col("purchase_date"),
    F.col("items")
)

df = user_purchases  # single input table also bound as df

# ---- solution ----
result = (
    df
    .select("user_id", F.explode(F.split(F.col("items"), ",")).alias("item_raw"))
    .select("user_id", F.trim(F.col("item_raw")).alias("item"))
    .groupBy("user_id")
    .agg(F.array_join(F.array_sort(F.collect_set("item")), ",").alias("all_items"))
    .orderBy("user_id")
)

result.show(truncate=False)

spark.stop()
