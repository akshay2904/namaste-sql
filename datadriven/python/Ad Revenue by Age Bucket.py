"""PySpark solution for: Ad Revenue by Age Bucket
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join ad_impressions with users on user_id, filter out null age buckets,
# group by age_bucket, sum revenue, and order descending
result = (
    ad_impressions.join(users, ad_impressions.user_id == users.user_id, "inner")
    .filter(users.age_bucket.isNotNull())
    .groupBy(users.age_bucket)
    .agg(F.sum(ad_impressions.revenue).alias("total_revenue"))
    .orderBy(F.col("total_revenue").desc())
)

result.show()
