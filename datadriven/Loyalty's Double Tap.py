"""PySpark solution for: Loyalty's Double Tap
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

impression_count = (
    ad_impressions.join(push_notifs, ad_impressions.user_id == push_notifs.user_id, "inner")
    .filter((F.col("clicked") == 1) & (F.lower(F.col("campaign")).like("%loyalty%")))
    .count()
)
