"""PySpark solution for: Campaign Click Rate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter to users who appear in page_views
viewed_users = page_views.select("user_id").distinct()
filtered_impressions = ad_impressions.join(viewed_users, "user_id", "inner")

# Calculate clicked percentage per campaign
result = (
    filtered_impressions
    .groupBy("ad_campaign")
    .agg(
        (
            F.sum(F.when(F.col("clicked") == 1, 1).otherwise(0)).cast("double") 
            * 100.0 / F.count("*")
        ).alias("clicked_pct")
    )
    .select(
        "ad_campaign",
        F.round("clicked_pct", 2).alias("clicked_pct")
    )
    .orderBy(F.desc("clicked_pct"), "ad_campaign")
)

result.show(truncate=False)
