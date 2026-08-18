"""PySpark solution for: Alert Response Breakdown
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    alert_events
    .withColumn("severity_lower", F.lower(F.col("severity")))
    .groupBy("svc_name")
    .agg(
        F.count("*").alias("total_alerts"),
        F.sum(F.when(F.col("severity_lower") == "critical", 1).otherwise(0)).alias("critical_count"),
        F.sum(F.when(F.col("severity_lower") == "high", 1).otherwise(0)).alias("high_count"),
        F.sum(F.when(F.col("ack_by").isNull(), 1).otherwise(0)).alias("unacked_count"),
        F.round(F.lit(1.0) * F.count("*") / F.countDistinct("status"), 2).alias("avg_per_status")
    )
    .drop("severity_lower")
    .orderBy(F.col("total_alerts").desc())
)
