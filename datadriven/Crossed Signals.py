"""PySpark solution for: Crossed Signals
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Assuming PySpark Session is already initialized and DataFrames are loaded

# Extract hour from impression_time and fired_at, then join on this hour
merged_df = ad_impressions.withColumn("imp_hour", F.date_trunc("hour", "impression_time")) \
                          .join(alert_events.withColumn("alert_hour", F.date_trunc("hour", "fired_at")), 
                                on=[F.col("imp_hour") == F.col("alert_hour")], 
                                how="inner") \
                          .select("ad_campaign", "alert_id", "status")  # Only select necessary columns

# Aggregate and count alerts and resolved alerts per campaign
result_df = merged_df.groupBy("ad_campaign") \
                     .agg(
                         F.countDistinct("alert_id").alias("alert_count"),
                         F.countDistinct(F.when(F.col("status") == "resolved", "alert_id")).alias("resolved_count")
                     ) \
                     .orderBy(F.col("alert_count").desc(), F.col("resolved_count").desc(), F.col("ad_campaign").desc())

# Show or collect the result (uncomment as necessary)
# result_df.show()
