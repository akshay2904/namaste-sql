"""PySpark solution for: Campaign Bookend Engagement
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Extract date from impression_time and compute campaign-level statistics
campaign_dates = (
    ad_impressions
    .groupBy("ad_campaign")
    .agg(
        F.min(F.to_date("impression_time")).alias("first_day"),
        F.max(F.to_date("impression_time")).alias("last_day")
    )
)

campaign_counts = (
    ad_impressions
    .groupBy("ad_campaign")
    .agg(F.count("*").alias("total_impressions"))
)

# Join back and compute percentages
result = (
    ad_impressions
    .join(campaign_dates, "ad_campaign")
    .join(campaign_counts, "ad_campaign")
    .groupBy("ad_campaign")
    .agg(
        (
            F.sum(F.when(F.to_date("impression_time") == F.col("first_day"), 1).otherwise(0))
            .cast("double") * 100.0 / F.first("total_impressions")
        ).alias("first_day_pct"),
        (
            F.sum(F.when(F.to_date("impression_time") == F.col("last_day"), 1).otherwise(0))
            .cast("double") * 100.0 / F.first("total_impressions")
        ).alias("last_day_pct")
    )
    .orderBy("ad_campaign")
)

result.select("ad_campaign", "first_day_pct", "last_day_pct").show()
