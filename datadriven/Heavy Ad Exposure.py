"""PySpark solution for: Heavy Ad Exposure
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

per_campaign = (
    ad_impressions
    .filter(F.col("user_id").isNotNull())
    .groupBy("user_id", "ad_campaign")
    .agg(F.count("*").alias("impressions"))
)

per_user = (
    per_campaign
    .groupBy("user_id")
    .agg(
        F.max("impressions").alias("hottest_campaign"),
        F.sum("impressions").alias("total_impressions"),
        F.count("*").alias("campaign_count")
    )
)

result = (
    per_user
    .filter(
        (F.col("hottest_campaign") >= 3) |
        ((F.col("total_impressions") >= 5) & (F.col("campaign_count") >= 2))
    )
    .select("user_id")
    .orderBy("user_id")
)
