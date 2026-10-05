"""PySpark solution for: Break Through
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    ad_impressions
    .groupBy("ad_campaign")
    .agg(
        F.round(100.0 * F.sum("clicked") / F.count("*"), 2).alias("ctr_pct"),
        F.sum("revenue").alias("total_revenue"),
        F.count("*").alias("impressions")
    )
    .filter(F.col("ctr_pct") > 20)
    .orderBy(F.col("ctr_pct").desc(), F.col("ad_campaign"))
)

result.show()
