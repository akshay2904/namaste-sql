"""PySpark solution for: Least Viewed Content
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Compute unique viewer count per page URL
viewer_counts = (
    page_views
    .groupBy("page_url")
    .agg(F.countDistinct("user_id").alias("unique_viewers"))
)

# Find the minimum viewer count across all pages
min_viewers = viewer_counts.agg(F.min("unique_viewers")).first()[0]

# Filter pages that match the minimum
result = (
    viewer_counts
    .filter(F.col("unique_viewers") == min_viewers)
    .select(
        F.col("page_url").alias("content_id"),
        F.col("unique_viewers")
    )
    .orderBy(F.col("unique_viewers").asc())
)

result.show()
