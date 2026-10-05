"""PySpark solution for: The Long Watch
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by content_type, count items, and average duration
result = (
    content_items
    .groupBy("content_type")
    .agg(
        F.count("*").alias("items_published"),
        F.avg("duration_seconds").alias("avg_runtime")
    )
    .orderBy(F.col("avg_runtime").desc())
)

result.show()
