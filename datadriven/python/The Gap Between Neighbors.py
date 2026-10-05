"""PySpark solution for: The Gap Between Neighbors
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

# Filter healthy checks
healthy = svc_health.filter(F.col("status") == "healthy")

# Self-join on region, different check_ids, and uptime within 5 points
joined = healthy.alias("s1").join(
    healthy.alias("s2"),
    (F.col("s1.region") == F.col("s2.region")) &
    (F.col("s1.check_id") != F.col("s2.check_id")) &
    (F.abs(F.col("s1.uptime") - F.col("s2.uptime")) <= 5)
)

# Compute absolute latency diff and aggregate by svc_name
result = joined.withColumn(
    "latency_diff", F.abs(F.col("s1.latency") - F.col("s2.latency"))
).groupBy("s1.svc_name").agg(
    F.avg("latency_diff").alias("avg_latency_diff")
).select(
    F.col("s1.svc_name").alias("svc_name"),
    "avg_latency_diff"
)

result.show()
