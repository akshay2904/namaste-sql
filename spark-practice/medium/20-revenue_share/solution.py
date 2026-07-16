"""
Revenue Share per Category  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/revenue_share

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("revenue_share").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "category": "Electronics", "amount": "1200"}, {"order_id": "2", "category": "Clothing", "amount": "800"}, {"order_id": "3", "category": "Electronics", "amount": "500"}, {"order_id": "4", "category": "Furniture", "amount": "950"}, {"order_id": "5", "category": "Clothing", "amount": "300"}]
orders = _make_df(_orders_rows, ['order_id', 'category', 'amount']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("category"),
    F.col("amount").cast("int").alias("amount")
)

df = orders  # single input table also bound as df

# ---- solution ----
totals = (
    df.groupBy("category")
    .agg(F.sum("amount").alias("total_revenue"))
)

grand_total_window = Window.rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

result = (
    totals
    .withColumn("revenue_pct",
        F.round(F.col("total_revenue") * 100.0 / F.sum("total_revenue").over(grand_total_window), 2)
    )
    .orderBy(F.desc("revenue_pct"))
)

result.show(truncate=False)

spark.stop()
