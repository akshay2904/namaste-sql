"""PySpark solution for: Where the Minutes Go
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Normalize device to lowercase and aggregate total dwell time per device
per_device = page_views \
    .withColumn("device", F.lower(F.col("device"))) \
    .groupBy("device") \
    .agg(F.sum("dur_ms").alias("total_dwell_ms"))

# Calculate running percentage with window functions
leaderboard = per_device \
    .withColumn("total_dwell_ms_sum", F.sum("total_dwell_ms").over(Window.orderBy(F.col("total_dwell_ms").desc()))) \
    .withColumn("total_dwell_ms_all", F.sum("total_dwell_ms").over(Window.partitionBy())) \
    .withColumn("running_pct", 
                F.round((F.col("total_dwell_ms_sum") / F.col("total_dwell_ms_all")) * 100, 2)) \
    .select("device", "total_dwell_ms", "running_pct") \
    .orderBy(F.col("total_dwell_ms").desc())

# Optionally drop the intermediate columns if needed (uncomment below)
# leaderboard = leaderboard.drop("total_dwell_ms_sum", "total_dwell_ms_all")
