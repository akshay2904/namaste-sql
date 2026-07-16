"""
Weekend vs Weekday Revenue  (medium)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/weekend_vs_weekday

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("weekend_vs_weekday").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_sales_rows = [{"sale_id": "1", "sale_date": "2024-01-01", "amount": "120"}, {"sale_id": "2", "sale_date": "2024-01-02", "amount": "85"}, {"sale_id": "3", "sale_date": "2024-01-03", "amount": "200"}, {"sale_id": "4", "sale_date": "2024-01-04", "amount": "150"}, {"sale_id": "5", "sale_date": "2024-01-05", "amount": "95"}]
sales = _make_df(_sales_rows, ['sale_id', 'sale_date', 'amount']).select(
    F.col("sale_id").cast("int").alias("sale_id"),
    F.col("sale_date"),
    F.col("amount").cast("int").alias("amount")
)

df = sales  # single input table also bound as df

# ---- solution ----
result = (
    df
    .withColumn(
        "day_type",
        F.when(F.dayofweek(F.col("sale_date")).isin(1, 7), "Weekend").otherwise("Weekday")
    )
    .groupBy("day_type")
    .agg(
        F.sum("amount").alias("total_revenue"),
        F.count("*").alias("num_sales")
    )
    .orderBy("day_type")
)

result.show(truncate=False)

spark.stop()
