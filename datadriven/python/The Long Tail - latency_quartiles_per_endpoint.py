"""PySpark solution for: The Long Tail
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter out null latency values and assign NTILE buckets per endpoint
tiered = (
    api_calls
    .filter(F.col("latency").isNotNull())
    .select(
        "endpoint",
        "latency",
        F.ntile(4)
         .over(Window.partitionBy("endpoint").orderBy("latency"))
         .alias("bucket")
    )
)

# Aggregate per endpoint and tier
result = (
    tiered
    .groupBy("endpoint", "bucket")
    .agg(
        F.min("latency").alias("min_latency"),
        F.max("latency").alias("max_latency"),
        F.avg("latency").alias("avg_latency")
    )
    .orderBy("endpoint", "bucket")
)
