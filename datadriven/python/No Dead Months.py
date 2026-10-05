"""PySpark solution for: No Dead Months
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate monthly clicks and spend
monthly = ad_impressions \
    .withColumn("month", F.date_format("impression_time", "yyyy-MM")) \
    .groupBy("ad_campaign", "month") \
    .agg(
        F.sum(F.when(F.col("clicked") == 1, 1).otherwise(0)).alias("monthly_clicks"),
        F.sum("revenue").alias("monthly_spend")
    )

# Filter campaigns with at least one click every month and aggregate max spend
result = monthly \
    .groupBy("ad_campaign") \
    .agg(
        F.min("monthly_clicks").alias("min_monthly_clicks"), 
        F.max("monthly_spend").alias("max_monthly_spend")
    ) \
    .filter(F.col("min_monthly_clicks") >= 1)

# Order by max spend and campaign, select campaign
result = result \
    .orderBy("max_monthly_spend", "ad_campaign") \
    .select("ad_campaign")
