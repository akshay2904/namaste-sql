"""PySpark solution for: Top 2 Ad Campaigns by Spend
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter out campaigns with 'test' in their name and handle potential NULL revenues
filtered_campaigns = ad_impressions.filter(~F.col("ad_campaign").contains("test")).withColumn("revenue", F.coalesce(F.col("revenue"), F.lit(0.0)))

# Calculate total revenue for each campaign
campaign_spend = filtered_campaigns.groupBy("ad_campaign").agg(F.sum("revenue").alias("total_revenue"))

# Rank campaigns by spend, allowing ties at the cutoff
ranked_campaigns = campaign_spend.withColumn(
    "rank",
    F.rank().over(Window.orderBy(F.col("total_revenue").desc()))
)

# Select top two (or more if tied) campaigns
top_campaigns = ranked_campaigns.filter(F.col("rank") <= 2).select("ad_campaign", "total_revenue")

# Optionally, drop the 'rank' column if not needed in the output (already excluded in select above)

top_campaigns.show()
