"""
Customers Above Average Spend  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/customers_above_avg

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("customers_above_avg").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "customer_id": "101", "amount": "150"}, {"order_id": "2", "customer_id": "102", "amount": "200"}, {"order_id": "3", "customer_id": "101", "amount": "300"}, {"order_id": "4", "customer_id": "103", "amount": "50"}, {"order_id": "5", "customer_id": "104", "amount": "400"}]
orders = _make_df(_orders_rows, ['order_id', 'customer_id', 'amount']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount")
)

df = orders  # single input table also bound as df

# ---- solution ----
totals = (
    df
    .groupBy("customer_id")
    .agg(F.sum("amount").alias("total_spend"))
)

avg_spend = totals.agg(F.avg("total_spend")).collect()[0][0]

result = (
    totals
    .filter(F.col("total_spend") > avg_spend)
    .orderBy(F.col("total_spend").desc())
)

result.show(truncate=False)

spark.stop()
