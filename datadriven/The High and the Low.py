"""PySpark solution for: The High and the Low
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Filter out test regions and null latencies
filtered = svc_health.filter(
    (~F.col("region").contains("test")) & (F.col("latency").isNotNull())
)

# Define windows for high and low latency ranking per region
window_spec_high = Window.partitionBy("region").orderBy(F.col("latency").desc())
window_spec_low = Window.partitionBy("region").orderBy(F.col("latency").asc())

# Add dense rank columns
ranked = filtered.withColumn(
    "high_rank", F.dense_rank().over(window_spec_high)
).withColumn(
    "low_rank", F.dense_rank().over(window_spec_low)
)

# Select rows that are either highest or lowest, and determine latency_type
result = ranked.filter(
    (F.col("high_rank") == 1) | (F.col("low_rank") == 1)
).withColumn(
    "latency_type",
    F.when(F.col("high_rank") == 1, "highest").otherwise("lowest")
).select(
    "svc_name", "region", "latency", "latency_type"
).orderBy("region", "latency_type", "svc_name")

result.show()
