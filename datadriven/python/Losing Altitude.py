"""PySpark solution for: Losing Altitude
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter to only June and October 2026 impressions, group by campaign and month
monthly_clicks = (
    ad_impressions
    .withColumn("ym", F.date_format("impression_time", "yyyy-MM"))
    .filter(F.col("ym").isin("2026-06", "2026-10"))
    .groupBy("ad_campaign", "ym")
    .agg(F.sum(F.when(F.col("clicked") == 1, 1).otherwise(0)).alias("total_clicks"))
)

# Rank campaigns within each month by total clicks
window_spec = Window.partitionBy("ym").orderBy(F.col("total_clicks").desc())
ranked = monthly_clicks.withColumn("rnk", F.dense_rank().over(window_spec))

# Separate June and October rankings and join to compare
june = ranked.filter(F.col("ym") == "2026-06").select(
    F.col("ad_campaign").alias("june_campaign"), F.col("rnk").alias("june_rnk")
)
october = ranked.filter(F.col("ym") == "2026-10").select(
    F.col("ad_campaign").alias("oct_campaign"), F.col("rnk").alias("oct_rnk")
)

result = (
    june.join(october, F.col("june_campaign") == F.col("oct_campaign"))
    .filter(F.col("oct_rnk") > F.col("june_rnk"))
    .select(F.col("june_campaign").alias("ad_campaign"))
    .orderBy("ad_campaign")
)

result.show()
