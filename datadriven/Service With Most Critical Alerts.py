"""PySpark solution for: Service With Most Critical Alerts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

critical_counts = (
    alert_events
    .filter(F.lower(F.col("severity")).contains("critical")) 
    .groupBy("svc_name")
    .agg(F.count("*").alias("critical_count"))
    .orderBy(F.col("critical_count").desc())
    .limit(1)
)

result = (
    alert_events
    .join(critical_counts.select("svc_name"), "svc_name")
    .select(alert_events["*"])
    .orderBy(F.col("fired_at"))
)

result.show()
