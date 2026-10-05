"""PySpark solution for: Endpoint Ranking
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Aggregate by endpoint: count total rows (excluding NULL latency) and average latency
endpoint_stats = (
    api_calls
    .filter(F.col("latency").isNotNull())  # skip rows where latency is NULL
    .groupBy("endpoint")
    .agg(
        F.count("*").alias("call_count"),
        F.avg("latency").alias("avg_latency")
    )
)

# Rank endpoints by average latency descending, ties share position
window_spec = Window.orderBy(F.col("avg_latency").desc())

result = (
    endpoint_stats
    .withColumn("position", F.rank().over(window_spec))
    .select("endpoint", "call_count", "avg_latency", "position")
    .orderBy("position", "endpoint")
)

result.show()
