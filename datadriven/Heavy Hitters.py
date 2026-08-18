"""PySpark solution for: Heavy Hitters
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Count commits per repo
repo_counts = repo_commits.groupBy("repo_name").agg(
    F.count("*").alias("commit_count")
)

# Calculate overall average commit count across all repos
avg_commit_count = repo_counts.agg(
    F.avg("commit_count").alias("avg_count")
).collect()[0]["avg_count"]

# Filter repos with commit count above average and sort descending
result = repo_counts.filter(
    F.col("commit_count") > avg_commit_count
).select("repo_name", "commit_count").orderBy(
    F.col("commit_count").desc()
)

result.show()
