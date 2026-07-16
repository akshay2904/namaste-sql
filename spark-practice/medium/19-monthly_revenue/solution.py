"""
Monthly Revenue Summary  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/monthly_revenue

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("monthly_revenue").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_orders_rows = [{"order_id": "1", "order_date": "2024-01-05", "amount": "1200", "category": "Electronics"}, {"order_id": "2", "order_date": "2024-01-15", "amount": "800", "category": "Clothing"}, {"order_id": "3", "order_date": "2024-01-28", "amount": "500", "category": "Electronics"}, {"order_id": "4", "order_date": "2024-02-03", "amount": "950", "category": "Furniture"}, {"order_id": "5", "order_date": "2024-02-14", "amount": "300", "category": "Clothing"}]
orders = _make_df(_orders_rows, ['order_id', 'order_date', 'amount', 'category']).select(
    F.col("order_id").cast("int").alias("order_id"),
    F.col("order_date"),
    F.col("amount").cast("int").alias("amount"),
    F.col("category")
)

df = orders  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn("month", F.date_format(F.col("order_date"), "yyyy-MM"))
    .groupBy("month")
    .agg(
        F.sum("amount").alias("total_revenue"),
        F.count("*").alias("num_orders")
    )
    .orderBy("month")
)

result.show(truncate=False)

spark.stop()
