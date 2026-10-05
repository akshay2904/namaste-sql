"""PySpark solution for: Peak Retargeting Revenue Month
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter and transform data
retargeting_2026 = ad_impressions.filter(
    (ad_impressions.ad_campaign.contains("retarget")) & 
    (F.year(ad_impressions.impression_time) == 2026)
).withColumn("mnth", F.month(ad_impressions.impression_time).cast("string")).withColumn("year", F.year(ad_impressions.impression_time).cast("string")).withColumn("mnth", F.concat_ws("-", "year", F.col("mnth")))

# Aggregate and calculate metrics
retargeting_metrics = retargeting_2026.groupBy("mnth").agg(
    F.sum("revenue").alias("total_revenue"),
    F.max("revenue").alias("max_revenue"),
    F.avg("revenue").alias("avg_revenue")
)

# Order by total_revenue in descending order and select top row
result = retargeting_metrics.orderBy(F.col("total_revenue").desc()).limit(1).select("mnth", "total_revenue", "max_revenue", "avg_revenue")

# Show result
result.show()
