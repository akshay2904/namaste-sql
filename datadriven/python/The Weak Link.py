"""PySpark solution for: The Weak Link
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Compute failure percentage per repository, worst first
result = (
    ci_builds
    .groupBy("repo_name")
    .agg(
        F.round(
            100.0 * F.sum(F.when(F.col("status") == "failed", 1).otherwise(0)) / F.count("*"),
            2
        ).alias("failure_pct")
    )
    .orderBy(F.col("failure_pct").desc(), F.col("repo_name"))
)

result.select("repo_name", "failure_pct")
