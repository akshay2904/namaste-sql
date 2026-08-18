"""PySpark solution for: The Warm Edges
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter edge locations that have at least one cache hit
cached_edges = cdn_logs.filter(F.col("cache_hit") == 1).select("edge_loc").distinct()

# Join with the filtered dataset, filter for api paths, group and aggregate
result = (
    cdn_logs.join(cached_edges, "edge_loc", "inner")
    .filter(F.col("req_path").contains("api"))
    .groupBy("edge_loc", "req_path")
    .agg(F.avg("bytes").alias("avg_bytes"))
    .orderBy("avg_bytes")
)

result.show(truncate=False)
