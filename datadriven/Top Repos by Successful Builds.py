"""PySpark solution for: Top Repos by Successful Builds
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

success_builds = ci_builds.filter(ci_builds.status == "success")
result = success_builds.groupBy("repo_name").agg(F.count("*").alias("success_count")) \
                        .orderBy(F.col("success_count").desc(), F.col("repo_name").asc())
