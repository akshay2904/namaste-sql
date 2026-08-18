"""PySpark solution for: First Light
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Compute first successful CI build timestamp per repo
first_success = (
    ci_builds
    .filter(F.col("status") == "success")
    .groupBy("repo_name")
    .agg(F.min("built_at").alias("first_success_at"))
)

# Join commits with first success and filter commits before that timestamp
result = (
    repo_commits
    .join(first_success, on="repo_name", how="inner")
    .filter(F.col("commit_at") < F.col("first_success_at"))
    .groupBy("author")
    .agg(
        F.avg("added").alias("avg_lines_added"),
        F.avg("removed").alias("avg_lines_removed")
    )
    .orderBy(F.col("avg_lines_added").desc())
)

result.show()
