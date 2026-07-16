"""
Percentile Rank of Sales  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/percentile_rank

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("percentile_rank").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_sales_reps_rows = [{"rep_id": "1", "name": "Alice", "region": "North", "total_sales": "82000"}, {"rep_id": "2", "name": "Bob", "region": "North", "total_sales": "95000"}, {"rep_id": "3", "name": "Carol", "region": "North", "total_sales": "71000"}, {"rep_id": "4", "name": "Dave", "region": "North", "total_sales": "110000"}, {"rep_id": "5", "name": "Eve", "region": "South", "total_sales": "63000"}]
sales_reps = _make_df(_sales_reps_rows, ['rep_id', 'name', 'region', 'total_sales']).select(
    F.col("rep_id").cast("int").alias("rep_id"),
    F.col("name"),
    F.col("region"),
    F.col("total_sales").cast("int").alias("total_sales")
)

df = sales_reps  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("region").orderBy(F.col("total_sales").desc())

result = (
    df
    .withColumn("pct_rank", F.round(F.percent_rank().over(w), 2))
    .withColumn("quartile", F.ntile(4).over(w))
    .select("rep_id", "name", "region", "total_sales", "pct_rank", "quartile")
    .orderBy("region", F.col("total_sales").desc())
)

result.show(truncate=False)

spark.stop()
