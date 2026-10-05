"""PySpark solution for: Deploy Velocity Swings
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Aggregate deployment counts per service and month
monthly = (
    deploy_logs
    .withColumn("deploy_month", F.date_format("deploy_at", "yyyy-MM"))
    .groupBy("svc_name", "deploy_month")
    .agg(F.count(F.lit(1)).alias("deploy_count"))
)

# Add previous month's count using window function
window_spec = Window.partitionBy("svc_name").orderBy("deploy_month")
with_lag = monthly.withColumn("prev_count", F.lag("deploy_count").over(window_spec))

# Filter out rows without a previous month and calculate percentage change
result = (
    with_lag
    .filter(F.col("prev_count").isNotNull())
    .withColumn(
        "pct_change",
        F.round((F.col("deploy_count") - F.col("prev_count")) * 100.0 / F.col("prev_count"), 2)
    )
    .select("svc_name", "deploy_month", "deploy_count", "prev_count", "pct_change")
    .orderBy("svc_name", "deploy_month")
)
