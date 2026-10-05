"""PySpark solution for: Largest CDN Response
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Parse bytes column: strip 'KB' suffix and convert to numeric
cdn_logs_parsed = cdn_logs.withColumn(
    "bytes_numeric",
    F.when(
        F.col("bytes").isNotNull(),
        F.when(
            F.col("bytes").cast("string").endswith("KB"),
            F.regexp_replace(F.col("bytes").cast("string"), "KB", "").cast("double") * 1024
        ).otherwise(F.col("bytes").cast("double"))
    )
)

# Filter for year 2026 and order by numeric bytes descending, take top 1
result = (
    cdn_logs_parsed
    .filter(F.year(F.col("served_at")) == 2026)
    .orderBy(F.col("bytes_numeric").desc())
    .limit(1)
    .select("log_id", "edge_loc", "req_path", "status", "bytes", "cache_hit", "served_at")
)

result.show()
