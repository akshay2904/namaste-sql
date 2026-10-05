"""PySpark solution for: Click-Through by Campaign
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by ad_campaign and calculate metrics
result = (ad_impressions
    .groupBy("ad_campaign")
    .agg(
        F.count("*").alias("total_impressions"),
        F.round(F.sum(F.when(F.col("clicked") == 1, 1).otherwise(0)).cast("double") * 100.0 / F.count("*"), 2).alias("clicked_pct"),
        F.round(F.sum(F.when(F.col("clicked") == 0, 1).otherwise(0)).cast("double") * 100.0 / F.count("*"), 2).alias("not_clicked_pct")
    )
    .orderBy("ad_campaign")
)

result.show()
