"""PySpark solution for: Endpoint Latency Spread
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter out zero latency entries
filtered_calls = api_calls.filter(F.col("latency") > 0)

# Group by endpoint and aggregate latency stats
result = (
    filtered_calls
    .groupBy("endpoint")
    .agg(
        (F.max("latency") - F.min("latency")).alias("latency_diff"),
        (F.max("latency") / F.min("latency")).alias("latency_ratio"),
        F.max("latency").alias("max_latency"),
        F.min("latency").alias("min_latency")
    )
    .orderBy(F.desc("latency_ratio"), "endpoint")
)

result.show(truncate=False)
