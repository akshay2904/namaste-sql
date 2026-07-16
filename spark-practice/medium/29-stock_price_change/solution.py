"""
Stock Price Daily Change  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/stock_price_change

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("stock_price_change").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_stock_prices_rows = [{"price_date": "2024-01-01", "stock": "AAPL", "close_price": "185.20"}, {"price_date": "2024-01-02", "stock": "AAPL", "close_price": "186.50"}, {"price_date": "2024-01-03", "stock": "AAPL", "close_price": "184.80"}, {"price_date": "2024-01-04", "stock": "AAPL", "close_price": "188.00"}, {"price_date": "2024-01-05", "stock": "AAPL", "close_price": "190.30"}]
stock_prices = _make_df(_stock_prices_rows, ['price_date', 'stock', 'close_price']).select(
    F.col("price_date"),
    F.col("stock"),
    F.col("close_price").cast("double").alias("close_price")
)

df = stock_prices  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("stock").orderBy("price_date")

result = (
    df
    .withColumn("price_change", F.col("close_price") - F.lag("close_price", 1).over(w))
    .select("stock", "price_date", "close_price", "price_change")
    .orderBy("stock", "price_date")
)

result.show(truncate=False)

spark.stop()
