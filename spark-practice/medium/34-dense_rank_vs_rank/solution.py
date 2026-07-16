"""
Dense Rank vs Rank  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/dense_rank_vs_rank

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("dense_rank_vs_rank").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_scores_rows = [{"student_id": "1", "name": "Alice", "subject": "Math", "score": "95"}, {"student_id": "2", "name": "Bob", "subject": "Math", "score": "88"}, {"student_id": "3", "name": "Carol", "subject": "Math", "score": "95"}, {"student_id": "4", "name": "Dave", "subject": "Math", "score": "72"}, {"student_id": "5", "name": "Eve", "subject": "Math", "score": "88"}]
scores = _make_df(_scores_rows, ['student_id', 'name', 'subject', 'score']).select(
    F.col("student_id").cast("int").alias("student_id"),
    F.col("name"),
    F.col("subject"),
    F.col("score").cast("int").alias("score")
)

df = scores  # single input table also bound as df

# ---- solution ----
w = Window.orderBy(F.col("score").desc())

result = (
    df
    .withColumn("rank", F.rank().over(w))
    .withColumn("dense_rank", F.dense_rank().over(w))
    .select("student_id", "name", "score", "rank", "dense_rank")
    .orderBy(F.col("score").desc(), "student_id")
)

result.show(truncate=False)

spark.stop()
