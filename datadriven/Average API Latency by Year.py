"""PySpark solution for: Average API Latency by Year
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    api_calls
    .withColumn("call_year", F.year("call_time"))
    .groupBy("call_year", "endpoint")
    .agg(F.avg("latency").alias("avg_latency"))
    .orderBy("call_year", "endpoint")
)
