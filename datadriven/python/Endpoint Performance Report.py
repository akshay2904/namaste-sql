"""PySpark solution for: Endpoint Performance Report
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by endpoint, aggregate metrics
result = (
    api_calls
    .groupBy("endpoint")
    .agg(
        F.count("*").alias("total_calls"),
        F.round(F.avg("latency"), 2).alias("avg_latency"),
        F.sum(F.when(F.col("latency") > 500, 1).otherwise(0)).alias("high_latency_count")
    )
    # Filter endpoints with at least 5 calls
    .filter(F.col("total_calls") >= 5)
    # Sort by total_calls descending, then endpoint
    .orderBy(F.col("total_calls").desc(), F.col("endpoint"))
)

result.select("endpoint", "total_calls", "avg_latency", "high_latency_count")
