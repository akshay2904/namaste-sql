"""PySpark solution for: Service Reliability Tiers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define the reliability tier mapping
reliability_tier = F.when(F.col("uptime") >= 99.9, "Platinum") \
    .when(F.col("uptime") >= 99.0, "Gold") \
    .when(F.col("uptime") >= 95.0, "Silver") \
    .otherwise("Bronze")

# Filter out 'maintenance' checks and assign reliability tiers
filtered_svc_health = svc_health \
    .filter(F.lower(F.col("status")) != F.lit("maintenance")) \
    .withColumn("tier", reliability_tier)

# Group by tier, calculate latency metrics, and sort by average latency in descending order
result = filtered_svc_health \
    .groupBy("tier") \
    .agg(
        F.min("latency").alias("min_latency"),
        F.avg("latency").alias("avg_latency"),
        F.max("latency").alias("max_latency")
    ) \
    .orderBy(F.col("avg_latency").desc())

# Show the result
result.show()
