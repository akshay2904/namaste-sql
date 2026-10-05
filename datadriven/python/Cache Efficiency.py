"""PySpark solution for: Cache Efficiency
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Compute per-edge aggregations
edge_stats = cdn_logs.groupBy("edge_loc").agg(
    F.count("*").alias("request_count"),
    F.sum("cache_hit").alias("total_cache_hits"),
    F.count("*").alias("total_count")
).withColumn(
    "hit_pct",
    F.round(100.0 * F.col("total_cache_hits") / F.col("total_count"), 2)
)

# Compute overall statistics across all edges
overall_stats = edge_stats.agg(
    F.sum("total_cache_hits").alias("overall_hits"),
    F.sum("total_count").alias("overall_count")
).withColumn(
    "overall_hit_pct",
    F.round(100.0 * F.col("overall_hits") / F.col("overall_count"), 2)
).select("overall_hit_pct")

# Join the overall percentage to every row and project required columns
result = edge_stats.crossJoin(overall_stats).select(
    "edge_loc",
    "request_count",
    "hit_pct",
    "overall_hit_pct"
).orderBy(F.col("hit_pct").desc(), F.col("edge_loc"))

result.show()
