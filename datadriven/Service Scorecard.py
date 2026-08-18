"""PySpark solution for: Service Scorecard
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

deploy_counts = deploy_logs.groupBy("svc_name").count().withColumnRenamed("count", "deploy_count")

result = deploy_counts.join(alert_events, deploy_counts.svc_name == alert_events.svc_name, "left") \
    .groupBy(deploy_counts.svc_name, deploy_counts.deploy_count) \
    .count().withColumnRenamed("count", "alert_count") \
    .select(deploy_counts.svc_name, deploy_counts.deploy_count, "alert_count")
