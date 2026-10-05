"""PySpark solution for: Biggest Deployment Decline
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter deployments for March and April 2026
deploy_filtered = deploy_logs.filter(
    (F.year("deploy_at") == 2026) & (F.month("deploy_at").isin(3, 4))
)

# Get distinct services from svc_health
health_services = svc_health.select("svc_name").distinct()

# Join deploy logs with health services
joined = deploy_filtered.join(health_services, "svc_name", "inner")

# Calculate deployments per service per month and find the decline
result = (
    joined.groupBy("svc_name")
    .agg(
        (F.sum(F.when(F.month("deploy_at") == 3, 1).otherwise(0))
         - F.sum(F.when(F.month("deploy_at") == 4, 1).otherwise(0))
        ).alias("deploy_decline")
    )
    .orderBy(F.col("deploy_decline").desc())
    .limit(1)
    .select("svc_name", "deploy_decline")
)

result.show()
