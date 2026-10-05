"""PySpark solution for: The Quiet Outlier
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by latency, filter those occurring at most 2 times, and get the max
result_df = (
    api_calls
    .groupBy("latency")
    .agg(F.count("*").alias("cnt"))
    .filter(F.col("cnt") <= 2)
    .agg(F.max("latency").alias("max_unique_latency"))
)
