"""PySpark solution for: Build Health
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    ci_builds
    .groupBy("repo_name")
    .agg(
        F.sum(F.when(F.col("status") == "success", 1).otherwise(0)).alias("success_count"),
        F.sum(F.when(F.col("status") == "failed", 1).otherwise(0)).alias("failed_count"),
        F.count("*").alias("total_builds")
    )
    .filter(F.col("total_builds") >= 3)
    .withColumn("success_rate", F.round(100.0 * F.col("success_count") / F.col("total_builds"), 3))
    .orderBy(F.col("success_rate").desc())
    .select("repo_name", "success_count", "failed_count", "total_builds", "success_rate")
)

result.show()
