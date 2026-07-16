"""
Running Total  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/running_total

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("running_total").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_date": "2024-01-01", "customer_id": "1", "amount": "150"}, {"order_date": "2024-01-02", "customer_id": "1", "amount": "200"}, {"order_date": "2024-01-03", "customer_id": "1", "amount": "100"}, {"order_date": "2024-01-01", "customer_id": "2", "amount": "300"}, {"order_date": "2024-01-02", "customer_id": "2", "amount": "50"}]
orders = _make_df(_orders_rows, ['order_date', 'customer_id', 'amount']).select(
    F.col("order_date"),
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("amount").cast("int").alias("amount")
)

df = orders  # single input table also bound as df

# ---- solution ----
window = (
    Window
    .partitionBy("customer_id")
    .orderBy("order_date")
    .rowsBetween(Window.unboundedPreceding, Window.currentRow)
)

result = df \
    .withColumn("running_total", F.sum("amount").over(window)) \
    .select("customer_id", "order_date", "amount", "running_total") \
    .orderBy("customer_id", "order_date")

result.show(truncate=False)

spark.stop()
