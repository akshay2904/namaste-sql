"""PySpark solution for: Not All Fires Are Equal
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter alerts from 2026 and group by service + severity with count > 1
alert_counts = (
    alert_events
    .filter(F.year("fired_at") == 2026)
    .groupBy("svc_name", "severity")
    .agg(F.count("*").alias("alert_count"))
    .filter(F.col("alert_count") > 1)
)

# Join with health check services and compute average alert count per severity
result = (
    alert_counts
    .join(svc_health.select("svc_name"), on="svc_name", how="inner")
    .groupBy("severity")
    .agg(F.round(F.avg("alert_count"), 1).alias("avg_alert_count"))
)

result.show()
