"""PySpark solution for: Build Success vs Failure by Repo
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by repo_name and aggregate counts and average duration
result = (ci_builds.groupBy("repo_name")
          .agg(
              F.sum(F.when(F.col("status") == "success", 1).otherwise(0)).alias("success_count"),
              F.sum(F.when(F.col("status") == "failure", 1).otherwise(0)).alias("failure_count"),
              F.avg("dur_secs").alias("avg_duration")
          )
          .orderBy("repo_name"))

result.show(truncate=False)
