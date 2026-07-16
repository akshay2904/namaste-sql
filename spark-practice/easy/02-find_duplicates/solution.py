"""
Find Duplicate Emails  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/find_duplicates

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("find_duplicates").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_users_rows = [{"email": "alice@example.com", "name": "Alice", "signup_date": "2024-01-01"}, {"email": "bob@example.com", "name": "Bob", "signup_date": "2024-01-02"}, {"email": "alice@example.com", "name": "Alice Smith", "signup_date": "2024-01-03"}, {"email": "charlie@example.com", "name": "Charlie", "signup_date": "2024-01-04"}, {"email": "bob@example.com", "name": "Bobby", "signup_date": "2024-01-05"}]
users = _make_df(_users_rows, ['email', 'name', 'signup_date']).select(
    F.col("email"),
    F.col("name"),
    F.col("signup_date")
)

df = users  # single input table also bound as df

# ---- solution ----
result = df \
    .groupBy("email") \
    .agg(F.count("*").alias("count")) \
    .filter(F.col("count") > 1) \
    .orderBy(F.desc("count"), "email")

result.show(truncate=False)

spark.stop()
