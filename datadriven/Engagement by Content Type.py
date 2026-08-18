"""PySpark solution for: Engagement by Content Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    content_items
    .groupBy("content_type")
    .agg(
        F.coalesce(F.sum("duration_seconds"), F.lit(0)).alias("total_duration"),
        F.count("*").alias("item_count")
    )
    .orderBy(F.desc("total_duration"), F.asc("content_type"))
)
