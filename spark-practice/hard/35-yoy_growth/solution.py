"""
Year-over-Year Revenue Growth  (hard)
Standalone, runnable PySpark solution for https://spark.vutrinh.net/problems/yoy_growth

Run:  spark-submit solution.py     (or: python solution.py, with pyspark installed)
Input data below is the sample from the site; swap in the real fixture to scale up.
"""
from pyspark.sql import SparkSession, Window
from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, StringType

spark = (SparkSession.builder.master("local[*]").appName("yoy_growth").getOrCreate())
spark.sparkContext.setLogLevel("WARN")


def _make_df(rows, cols):
    schema = StructType([StructField(c, StringType(), True) for c in cols])
    data = [tuple(None if r.get(c) is None else str(r.get(c)) for c in cols) for r in rows]
    return spark.createDataFrame(data, schema)


# ---- input data (sample) ----
_annual_revenue_rows = [{"year": "2021", "category": "Electronics", "revenue": "500000"}, {"year": "2022", "category": "Electronics", "revenue": "620000"}, {"year": "2023", "category": "Electronics", "revenue": "590000"}, {"year": "2024", "category": "Electronics", "revenue": "710000"}, {"year": "2021", "category": "Clothing", "revenue": "280000"}]
annual_revenue = _make_df(_annual_revenue_rows, ['year', 'category', 'revenue']).select(
    F.col("year").cast("int").alias("year"),
    F.col("category"),
    F.col("revenue").cast("int").alias("revenue")
)

df = annual_revenue  # single input table also bound as df

# ---- solution ----
w = Window.partitionBy("category").orderBy("year")

result = (
    df
    .withColumn("prev_revenue", F.lag("revenue", 1).over(w))
    .withColumn(
        "yoy_growth_pct",
        F.round((F.col("revenue") - F.col("prev_revenue")) / F.col("prev_revenue") * 100, 2)
    )
    .select("category", "year", "revenue", "yoy_growth_pct")
    .orderBy("category", "year")
)

result.show(truncate=False)

spark.stop()
