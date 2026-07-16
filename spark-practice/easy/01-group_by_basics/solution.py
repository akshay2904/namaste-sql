"""
Group By Basics  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/group_by_basics

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("group_by_basics").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_data_rows = [{"customer_id": "1", "amount": "100"}, {"customer_id": "2", "amount": "200"}, {"customer_id": "1", "amount": "150"}, {"customer_id": "3", "amount": "300"}, {"customer_id": "2", "amount": "50"}]
data = _make_df(_data_rows, ['customer_id', 'amount']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount")
)

df = data  # single input table also bound as df

# ---- solution ----
result = df \
    .groupBy("customer_id") \
    .agg(F.sum("amount").alias("total_amount"))

result.show(truncate=False)

spark.stop()
