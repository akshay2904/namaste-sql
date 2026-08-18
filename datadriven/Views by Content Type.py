"""PySpark solution for: Views by Content Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join content views with items to get content type, then count views per content type
result = content_views.join(content_items, "content_id") \
    .groupBy("content_type") \
    .agg(F.count("*").alias("view_count"))
