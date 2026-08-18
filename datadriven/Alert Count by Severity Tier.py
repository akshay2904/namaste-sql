"""PySpark solution for: Alert Count by Severity Tier
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    alert_events
    .select(F.coalesce(F.col("severity"), F.lit("unknown")).alias("severity_tier"))
    .groupBy("severity_tier")
    .agg(F.count("*").alias("alert_count"))
    .orderBy(F.col("alert_count").desc())
)

result.select("severity_tier", "alert_count").show()
