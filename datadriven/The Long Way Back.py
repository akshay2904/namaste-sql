"""PySpark solution for: The Long Way Back
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Step 1: Extract month from 'checked' and add to DataFrame
svc_health_monthly = svc_health.withColumn("checked_month", F.date_format(F.to_date("checked"), "yyyy-MM")) \
    .select("svc_name", "checked_month", "uptime")

# Step 2: Calculate month-over-month differences to identify trends
window_order = Window.partitionBy("svc_name").orderBy("checked_month")
svc_health_trend = svc_health_monthly.withColumn("prev_uptime", F.lag("uptime").over(window_order)) \
    .withColumn("trend", F.when(F.col("uptime") > F.col("prev_uptime"), "rise") \
                 .when(F.col("uptime") < F.col("prev_uptime"), "fall") \
                 .otherwise("steady"))

# Step 3: Identify the start of each trend stretch
window_trend_start = Window.partitionBy("svc_name").orderBy("checked_month")
svc_health_stretch = svc_health_trend.withColumn("trend_change", F.when(F.col("trend") != F.lag("trend", 1, None).over(window_trend_start), 1).otherwise(0)) \
    .withColumn("stretch_id", F.sum("trend_change").over(window_trend_start))

# Step 4: Separate decline and recovery stretches, and calculate key metrics
decline_stretches = svc_health_stretch.filter(F.col("trend") == "fall") \
    .groupBy("svc_name", "stretch_id") \
    .agg(F.min("uptime").alias("decline_low"), F.min("checked_month").alias("decline_start"))

recovery_stretches = svc_health_stretch.filter(F.col("trend") == "rise") \
    .groupBy("svc_name", "stretch_id") \
    .agg(F.max("uptime").alias("recovery_high"), F.min("checked_month").alias("recovery_start"))

# Step 5: Match decline with subsequent recovery stretches and calculate growth ratio
decline_recovery_matches = decline_stretches.join(recovery_stretches, 
                                                 (decline_stretches.svc_name == recovery_stretches.svc_name) & 
                                                 (recovery_stretches.recovery_start > decline_stretches.decline_start), 
                                                 how="cross")

growth_ratios = decline_recovery_matches.select(
    decline_stretches.svc_name.alias("svc_name"), 
    decline_stretches.decline_start, 
    recovery_stretches.recovery_start,
    ((recovery_stretches.recovery_high - decline_stretches.decline_low) / decline_stretches.decline_low).alias("growth_ratio"))

# Final output
growth_ratios.show()
