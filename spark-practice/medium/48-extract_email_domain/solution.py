"""
Extract Email Domain  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/extract_email_domain

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("extract_email_domain").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_users_rows = [{"user_id": "1", "name": "Alice Johnson", "email": "alice@gmail.com"}, {"user_id": "2", "name": "Bob Smith", "email": "bob.smith@yahoo.com"}, {"user_id": "3", "name": "Carol White", "email": "carol@company.org"}, {"user_id": "4", "name": "Dave Brown", "email": "dave@hotmail.com"}, {"user_id": "5", "name": "Eve Davis", "email": "eve.davis@outlook.com"}]
users = _make_df(_users_rows, ['user_id', 'name', 'email']).select(
    F.col("user_id").cast("int").alias("user_id"),
    F.col("name"),
    F.col("email")
)

df = users  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("domain", F.regexp_extract(F.col("email"), "@(.+)$", 1))
    .select("user_id", "name", "email", "domain")
    .orderBy("user_id")
)

result.show(truncate=False)

spark.stop()
