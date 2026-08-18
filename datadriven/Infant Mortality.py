"""PySpark solution for: Infant Mortality
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter Q1 2026 and calculate failure counts
q1_2026_svc_health = svc_health.filter((F.col("checked") >= "2026-01-01") & (F.col("checked") < "2026-04-01") & F.col("status").isNotNull()) \
    .withColumn("is_unhealthy", F.when(F.lower(F.col("status")) != "healthy", 1).otherwise(0))

# Group by svc_name and calculate ratios
svc_failure_ratios = q1_2026_svc_health.groupBy("svc_name") \
    .agg(
        F.sum("is_unhealthy").alias("unhealthy_count"),
        F.count("*").alias("total_checks"),
        F.min("checked").alias("earliest_check")
    )

# To filter in HAVING if needed explicitly 
svc_failure_ratios = svc_failure_ratios.filter(F.col("earliest_check") >= "2026-01-01") \
    .withColumn("negative_ratio", F.col("unhealthy_count") / F.col("total_checks")) \
    .filter(F.col("negative_ratio") > 0.2) \
    .select("svc_name", "negative_ratio")
