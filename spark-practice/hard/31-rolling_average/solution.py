"""
7-Day Rolling Average  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/rolling_average

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("rolling_average").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_daily_sales_rows = [{"sale_date": "2024-01-01", "amount": "120"}, {"sale_date": "2024-01-02", "amount": "95"}, {"sale_date": "2024-01-03", "amount": "150"}, {"sale_date": "2024-01-04", "amount": "110"}, {"sale_date": "2024-01-05", "amount": "180"}]
daily_sales = _make_df(_daily_sales_rows, ['sale_date', 'amount']).select(
    F.col("sale_date"),
    F.col("amount").cast("int").alias("amount")
)

df = daily_sales  # single input table also bound as df

# ---- solution ----
w = Window.orderBy("sale_date").rowsBetween(-6, 0)

result = (
    df
    .withColumn("rolling_avg_7d", F.round(F.avg("amount").over(w), 2))
    .select("sale_date", "amount", "rolling_avg_7d")
    .orderBy("sale_date")
)

result.show(truncate=False)

spark.stop()
