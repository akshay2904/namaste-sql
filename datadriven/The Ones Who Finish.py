"""PySpark solution for: The Ones Who Finish
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Assuming 'content_views' and 'content_items' are already loaded as DataFrames

result = (
    content_views
    .join(content_items, content_views.content_id == content_items.content_id)
    .filter(F.year(content_views.viewed_at) == 2026)  # Filter views from this year
    .filter(content_items.duration_seconds > 0)  # Ignore items with no recorded length
    .withColumn("completion_rate", F.col("watch_seconds") / F.col("duration_seconds"))  # Calculate completion rate per view
    .groupBy(content_items.content_type.alias("content_format"))  # Group by content format
    .agg(
        F.round(F.avg("completion_rate"), 3).alias("avg_completion_rate"),  # Average completion rate
        F.count("*").alias("view_count")  # Count of views per format
    )
    .orderBy(F.col("avg_completion_rate").desc())  # Sort by avg completion rate in descending order
)

result.show()
