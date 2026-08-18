"""PySpark solution for: Deploy Outcomes by Service
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    deploy_logs
    .groupBy("svc_name")
    .agg(
        F.sum(F.when(F.lower(F.col("status")).like("%success%"), 1).otherwise(0)).alias("success_count"),
        F.sum(F.when(F.lower(F.col("status")) == "failed", 1).otherwise(0)).alias("failed_count"),
        F.sum(F.when(F.col("status") == "rolled_back", 1).otherwise(0)).alias("rolled_back_count")
    )
    .orderBy("svc_name")
)
