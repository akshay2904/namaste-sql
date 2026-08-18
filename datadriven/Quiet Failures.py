"""PySpark solution for: Quiet Failures
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter production deployments (case-insensitive) and count successes per row
production_deployments = deploy_logs.filter(F.lower("env_name") == "production") \
    .withColumn("is_success", F.when(F.lower("status") == "success", 1).otherwise(0))

# Aggregate per service: total deployments, successful deployments, and success rate
service_report = production_deployments.groupBy("svc_name") \
    .agg(
        F.count("*").alias("deploy_count"),
        F.sum("is_success").alias("success_count")
    ) \
    .withColumn("success_pct", F.round(F.col("success_count") / F.col("deploy_count") * 100.0, 1))

# Filter services with at least 3 production deployments and sort by success rate and name
result = service_report.filter(F.col("deploy_count") >= 3) \
    .orderBy(F.col("success_pct").asc(), F.col("svc_name").asc()) \
    .select("svc_name", "deploy_count", "success_count", "success_pct")

result.show()
