"""
Top Customers by Region  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/top_customers_region

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("top_customers_region").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_customers_rows = [{"customer_id": "1", "name": "Alice", "region": "North", "total_spend": "4500"}, {"customer_id": "2", "name": "Bob", "region": "North", "total_spend": "7200"}, {"customer_id": "3", "name": "Carol", "region": "North", "total_spend": "3100"}, {"customer_id": "4", "name": "Dave", "region": "North", "total_spend": "8900"}, {"customer_id": "5", "name": "Eve", "region": "North", "total_spend": "6300"}]
customers = _make_df(_customers_rows, ['customer_id', 'name', 'region', 'total_spend']).select(
    F.col("customer_id").cast("int").alias("customer_id"),
    F.col("name"),
    F.col("region"),
    F.col("total_spend").cast("int").alias("total_spend")
)

df = customers  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("region").orderBy(F.col("total_spend").desc())

result = (
    df
    .withColumn("rank", F.rank().over(w))
    .filter(F.col("rank") <= 2)
    .select("region", "customer_id", "name", "total_spend", "rank")
    .orderBy("region", "rank")
)

result.show(truncate=False)

spark.stop()
