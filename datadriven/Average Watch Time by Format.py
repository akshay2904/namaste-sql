"""PySpark solution for: Average Watch Time by Format
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join content_items with content_views on content_id
joined_df = content_items.join(content_views, content_items.content_id == content_views.content_id, "inner")

# Group by content_type and calculate average watch_seconds
result_df = (joined_df
    .groupBy(content_items.content_type)
    .agg(F.avg(content_views.watch_seconds).alias("avg_watch_time"))
    .orderBy("content_type")
)

result_df.show()
