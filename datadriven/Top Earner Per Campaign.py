"""PySpark solution for: Top Earner Per Campaign
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window to rank users by total revenue within each campaign
window = Window.partitionBy("ad_campaign").orderBy(F.col("total_revenue").desc())

# Filter out non-attributed impressions, aggregate revenue, and rank users
top_earners = ad_impressions.filter(F.col("user_id").isNotNull()) \
    .groupBy("ad_campaign", "user_id") \
    .agg(F.sum("revenue").alias("total_revenue")) \
    .withColumn("rnk", F.rank().over(window)) \
    .filter("rnk = 1") \
    .select("ad_campaign", "user_id", "total_revenue") \
    .orderBy("ad_campaign", "user_id")
