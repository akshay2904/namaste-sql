"""PySpark solution for: The Severity Matrix
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Normalize severity to lowercase, then pivot counts by severity level
severity_counts = (
    alert_events
    .withColumn("severity_lower", F.lower(F.col("severity")))
    .groupBy("svc_name")
    .pivot("severity_lower", ["critical", "high", "medium", "low"])
    .agg(F.count(F.lit(1)))
    .fillna(0)
)

# Add total count and rename columns
result = (
    severity_counts
    .withColumn("total_count", 
                F.col("critical") + F.col("high") + F.col("medium") + F.col("low"))
    .select(
        F.col("svc_name"),
        F.col("critical").alias("critical_count"),
        F.col("high").alias("high_count"),
        F.col("medium").alias("medium_count"),
        F.col("low").alias("low_count"),
        F.col("total_count")
    )
    .orderBy(F.col("total_count").desc(), F.col("svc_name").asc())
)
