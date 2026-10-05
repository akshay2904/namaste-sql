"""PySpark solution for: The One That Flew
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter out NULL durations, order by duration then built_at, take first row
result = (
    ci_builds
    .filter(F.col("dur_secs").isNotNull())
    .orderBy(F.col("dur_secs").asc(), F.col("built_at").asc())
    .select(F.col("built_at"), F.col("dur_secs").alias("min_duration"))
    .limit(1)
)
