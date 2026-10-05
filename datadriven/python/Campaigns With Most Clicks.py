"""PySpark solution for: Campaigns With Most Clicks
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter clicked impressions and aggregate
result = (
    ad_impressions
    .filter(F.col("clicked") == 1)
    .groupBy("ad_campaign")
    .agg(
        F.count("*").alias("total_clicks"),
        F.max("revenue").alias("max_impression_revenue")
    )
    .orderBy(F.col("total_clicks").desc())
)
