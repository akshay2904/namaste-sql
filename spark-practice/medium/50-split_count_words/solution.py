"""
Split and Count Words  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/split_count_words

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("split_count_words").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_reviews_rows = [{"review_id": "1", "product_id": "101", "review_text": "great product love quality great packaging great delivery"}, {"review_id": "2", "product_id": "101", "review_text": "love product amazing quality product works great"}, {"review_id": "3", "product_id": "102", "review_text": "product quality excellent love packaging excellent"}, {"review_id": "4", "product_id": "102", "review_text": "quality product amazing delivery love great product"}, {"review_id": "5", "product_id": "103", "review_text": "excellent product love quality delivery fast amazing"}]
reviews = _make_df(_reviews_rows, ['review_id', 'product_id', 'review_text']).select(
    F.col("review_id").cast("int").alias("review_id"),
    F.col("product_id").cast("int").alias("product_id"),
    F.col("review_text")
)

df = reviews  # single input table also bound as df

# ---- solution ----
stop_words = ["the", "and", "for", "this", "was", "very", "are", "with", "that"]

result = (
    df
    .select(F.explode(F.split(F.lower(F.col("review_text")), " ")).alias("word"))
    .filter(F.length(F.col("word")) >= 3)
    .filter(~F.col("word").isin(stop_words))
    .groupBy("word")
    .agg(F.count("*").alias("count"))
    .orderBy(F.col("count").desc(), F.col("word").asc())
    .limit(5)
)

result.show(truncate=False)

spark.stop()
