"""
Next Purchase Date  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/next_purchase_date

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("next_purchase_date").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_purchases_rows = [{"purchase_id": "1", "customer_id": "101", "purchase_date": "2024-01-05", "amount": "120"}, {"purchase_id": "2", "customer_id": "102", "purchase_date": "2024-01-03", "amount": "200"}, {"purchase_id": "3", "customer_id": "101", "purchase_date": "2024-01-12", "amount": "85"}, {"purchase_id": "4", "customer_id": "103", "purchase_date": "2024-01-07", "amount": "310"}, {"purchase_id": "5", "customer_id": "102", "purchase_date": "2024-01-15", "amount": "150"}]
purchases = _make_df(_purchases_rows, ['purchase_id', 'customer_id', 'purchase_date', 'amount']).select(
    F.col("purchase_id").cast("int").alias("purchase_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("purchase_date"),
    F.col("amount").cast("int").alias("amount")
)

df = purchases  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("customer_id").orderBy("purchase_date")

result = (
    df
    .withColumn("next_purchase_date", F.lead("purchase_date", 1).over(w))
    .select("purchase_id", "customer_id", "purchase_date", "next_purchase_date")
    .orderBy("customer_id", "purchase_date")
)

result.show(truncate=False)

spark.stop()
