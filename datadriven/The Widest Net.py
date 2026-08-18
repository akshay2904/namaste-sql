"""PySpark solution for: The Widest Net
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by ad_campaign, count distinct user_ids where clicked=1
result = (
    ad_impressions
    .groupBy("ad_campaign")
    .agg(
        F.countDistinct(
            F.when(F.col("clicked") == 1, F.col("user_id"))
        ).alias("users_reached")
    )
    .orderBy(F.desc("users_reached"), F.asc("ad_campaign"))
)

result.select("ad_campaign", "users_reached").show()
