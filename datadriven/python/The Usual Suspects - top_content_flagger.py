"""PySpark solution for: The Usual Suspects
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import sum

svc_names_with_alerts = alert_events.select("svc_name").distinct()
svc_names_with_alerts.createOrReplaceTempView("svc_names_with_alerts")

err_tracks_with_alerts = err_tracks.join(svc_names_with_alerts, "svc_name")
err_tracks_with_alerts = err_tracks_with_alerts.groupBy("svc_name").agg(sum("count").alias("total_errors"))
err_tracks_with_alerts = err_tracks_with_alerts.orderBy("total_errors", ascending=False)
