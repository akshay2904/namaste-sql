"""PySpark solution for: Top Content by Watch Time
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create content_stats DataFrame
content_stats = content_items.join(content_views, content_items.content_id == content_views.content_id) \
    .filter(content_views.watch_seconds.isNotNull()) \
    .groupBy(content_items.content_id, content_items.title) \
    .agg(F.sum(content_views.watch_seconds).alias("lifetime_value"), F.count("*").alias("view_count")) \
    .filter(F.col("view_count") >= 1)

# Create ranked DataFrame
ranked = content_stats.withColumn("rnk", F.dense_rank().over(Window.orderBy(F.col("lifetime_value").desc())))

# Select top 3 tiers
result = ranked.filter(F.col("rnk") <= 3).select("content_id", "title", "lifetime_value")
