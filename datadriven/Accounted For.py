"""PySpark solution for: Accounted For
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    ad_impressions
    .join(users, ad_impressions.user_id == users.user_id, "left")
    .groupBy(ad_impressions.ad_campaign)
    .agg(
        (
            F.round(
                F.sum(F.when(users.user_id.isNotNull(), 1).otherwise(0)).cast("double")
                * 100.0 / F.count("*"),
                1
            )
        ).alias("attributable_pct")
    )
    .orderBy(F.col("attributable_pct").desc(), F.col("ad_campaign"))
)
