"""
Remove Statistical Outliers  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/remove_outliers

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("remove_outliers").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_transactions_rows = [{"transaction_id": "1", "amount": "50"}, {"transaction_id": "2", "amount": "55"}, {"transaction_id": "3", "amount": "48"}, {"transaction_id": "4", "amount": "62"}, {"transaction_id": "5", "amount": "57"}]
transactions = _make_df(_transactions_rows, ['transaction_id', 'amount']).select(
    F.col("transaction_id").cast("int").alias("transaction_id"),
    F.col("amount").cast("int").alias("amount")
)

df = transactions  # single input table also bound as df

# ---- solution ----
stats = df.agg(
    F.percentile_approx("amount", 0.25).alias("q1"),
    F.percentile_approx("amount", 0.75).alias("q3")
).collect()[0]

q1, q3 = stats["q1"], stats["q3"]
iqr = q3 - q1
lower = q1 - 1.5 * iqr
upper = q3 + 1.5 * iqr

result = (
    df
    .filter((F.col("amount") >= lower) & (F.col("amount") <= upper))
    .orderBy("transaction_id")
)

result.show(truncate=False)

spark.stop()
