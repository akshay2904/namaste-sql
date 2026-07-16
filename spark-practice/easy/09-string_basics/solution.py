"""
String Basics  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/string_basics

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("string_basics").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_customers_rows = [{"customer_id": "1", "first_name": "  alice  ", "last_name": "Smith", "email": "alice@example.com", "city": "new york"}, {"customer_id": "2", "first_name": "BOB", "last_name": "johnson", "email": "BOB@EXAMPLE.COM", "city": "  London"}, {"customer_id": "3", "first_name": "Charlie", "last_name": "  BROWN  ", "email": "charlie@example.com", "city": "paris"}, {"customer_id": "4", "first_name": "diana", "last_name": "Williams", "email": "diana@example.com", "city": "BERLIN"}, {"customer_id": "5", "first_name": "  EVE  ", "last_name": "Davis", "email": "eve@example.com", "city": "tokyo"}]
customers = _make_df(_customers_rows, ['customer_id', 'first_name', 'last_name', 'email', 'city']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("first_name"),
    F.col("last_name"),
    F.col("email"),
    F.col("city")
)

df = customers  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("full_name", F.initcap(F.concat(F.trim(F.col("first_name")), F.lit(" "), F.trim(F.col("last_name")))))
    .withColumn("email", F.lower(F.trim(F.col("email"))))
    .withColumn("city", F.initcap(F.trim(F.col("city"))))
    .select("customer_id", "full_name", "email", "city")
    .orderBy("customer_id")
)

result.show(truncate=False)

spark.stop()
