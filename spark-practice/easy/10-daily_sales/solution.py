"""
Daily Sales Total  (easy)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/daily_sales

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("daily_sales").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_sales_rows = [{"sale_id": "1", "store_id": "1", "sale_date": "2024-01-01", "amount": "450"}, {"sale_id": "2", "store_id": "2", "sale_date": "2024-01-01", "amount": "820"}, {"sale_id": "3", "store_id": "1", "sale_date": "2024-01-01", "amount": "310"}, {"sale_id": "4", "store_id": "3", "sale_date": "2024-01-02", "amount": "650"}, {"sale_id": "5", "store_id": "1", "sale_date": "2024-01-02", "amount": "900"}]
sales = _make_df(_sales_rows, ['sale_id', 'store_id', 'sale_date', 'amount']).select(
    F.col("sale_id").cast("int").alias("sale_id"),
    F.col("store_id").cast("int").alias("store_id"),
    F.col("sale_date"),
    F.col("amount").cast("int").alias("amount")
)

df = sales  # single input table also bound as df

# ---- solution ----
result = (
    df
    .groupBy("sale_date")
    .agg(
        F.sum("amount").alias("total_amount"),
        F.count("*").alias("num_transactions")
    )
    .orderBy("sale_date")
)

result.show(truncate=False)

spark.stop()
