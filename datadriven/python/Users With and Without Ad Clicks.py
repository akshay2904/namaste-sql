"""PySpark solution for: Users With and Without Ad Clicks
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get distinct users who have clicked at least one ad
clicked_users = (
    ad_impressions.filter(F.col("clicked") == 1)
    .select("user_id")
    .distinct()
    .withColumn("has_click", F.lit(1))
)

# Left join with users to classify each user and count by group
result = (
    users.join(clicked_users, on="user_id", how="left")
    .withColumn(
        "click_group",
        F.when(F.col("has_click").isNotNull(), "has_click").otherwise("no_click")
    )
    .groupBy("click_group")
    .agg(F.count("*").alias("user_count"))
)
