"""PySpark solution for: Builds per Author per Branch
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by trigger and branch, count builds, then sort
result = (
    ci_builds
    .groupBy(F.col("trigger").alias("author"), "branch")
    .agg(F.count("*").alias("build_count"))
    .orderBy(
        F.col("author").asc(),
        F.col("branch").asc(),
        F.col("build_count").desc()
    )
)
