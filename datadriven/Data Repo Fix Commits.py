"""PySpark solution for: Data Repo Fix Commits
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

filtered = repo_commits.filter(
    F.lower(F.col("repo_name")).contains("data")
    & ~F.lower(F.col("repo_name")).contains("analytics")
    & F.lower(F.col("message")).contains("fix")
)

result = (
    filtered.groupBy("repo_name", "author")
    .agg(F.count("*").alias("fix_count"))
    .orderBy(F.col("fix_count").desc())
)

result.show()
