"""PySpark solution for: Every Touch Counts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter ad impressions and search queries for 2026
ad_impressions_2026 = ad_impressions.filter(F.year(F.col("impression_time")) == 2026)
search_queries_2026 = search_queries.filter(F.year(F.col("query_time")) == 2026)

# Union the filtered DataFrames
activity = ad_impressions_2026.select("user_id").unionByName(search_queries_2026.select("user_id"))

# Group by user_id and count touchpoints, aliasing the count column correctly
touchpoint_counts = activity.groupBy("user_id").count().withColumnRenamed("count", "touchpoint_count")

# Order by touchpoint count and user_id, referencing the column correctly
result = touchpoint_counts.orderBy(F.col("touchpoint_count").desc(), F.col("user_id"))

# Show the result (optional, for verification)
result.show()
