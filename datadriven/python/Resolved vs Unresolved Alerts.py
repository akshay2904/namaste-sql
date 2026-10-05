"""PySpark solution for: Resolved vs Unresolved Alerts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Normalize severity levels to standard case (e.g., all lowercase)
# Assuming 'COALESCE(resolved, '0')' logic treats None as unresolved (0)
# Here, we directly check if 'resolved' is not null (since '0' is not a possible value in the data)
# and treat missing (None) as unresolved

resolved_count = F.sum(F.when(F.col("resolved").isNotNull(), 1).otherwise(0))
unresolved_count = F.sum(F.when(F.col("resolved").isNull(), 1).otherwise(0))

# Group by severity, normalizing case to ensure 'HIGH' and 'high' are not separate
result = (
    alert_events
    .withColumn("severity_lower", F.lower(F.col("severity")))  # Normalize severity case
    .groupBy("severity_lower")  # Group by normalized severity
    .agg(
        F.count("severity_lower").alias("total_count"),  # Count all (for validation, not required)
        resolved_count.alias("resolved_count"),
        unresolved_count.alias("unresolved_count")
    )
    .select("severity_lower", "resolved_count", "unresolved_count")  # Only select required columns
)

# (Optional) If you want to preserve original severity case in output but group by case-insensitive
# (This would require an additional step to get the first severity value per group, assuming consistency)
# .withColumn("first_severity", F.first("severity").over(Window.partitionBy("severity_lower")))
# .groupBy("severity_lower", "first_severity")
# .agg(...)  # and then select "first_severity" as "severity" instead of "severity_lower"

result.show()
