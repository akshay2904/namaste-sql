"""PySpark solution for: Regions by Alert Volume
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

incident_heatmap = (
    alert_events
    .join(svc_health, alert_events.svc_name == svc_health.svc_name)
    .groupBy(svc_health.region)
    .count()
    .withColumnRenamed("count", "alert_count")
    .withColumnRenamed("region", "region")
    .orderBy(F.col("alert_count").desc())
    .select("region", "alert_count")
)
