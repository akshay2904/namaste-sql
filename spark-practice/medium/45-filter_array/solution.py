"""
Filter Users by Interest  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/filter_array

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("filter_array").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_user_interests_rows = [{"user_id": "1", "name": "Alice", "interests": "Technology,Sports,Music"}, {"user_id": "2", "name": "Bob", "interests": "Cooking,Travel"}, {"user_id": "3", "name": "Carol", "interests": "Technology,Art,Cooking"}, {"user_id": "4", "name": "Dave", "interests": "Sports,Gaming"}, {"user_id": "5", "name": "Eve", "interests": "Technology,Finance,Travel"}]
user_interests = _make_df(_user_interests_rows, ['user_id', 'name', 'interests']).select(
    F.col("user_id").cast("int").alias("user_id"),
    F.col("name"),
    F.col("interests")
)

df = user_interests  # single input table also bound as df

# ---- solution ----
result = (
    df
    .filter(F.array_contains(F.split(F.col("interests"), ","), "Technology"))
    .select("user_id", "name")
    .orderBy("user_id")
)

result.show(truncate=False)

spark.stop()
