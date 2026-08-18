"""PySpark solution for: Fresh Ink
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Get the maximum commit year and calculate the threshold year
max_year = repo_commits.agg(F.year(F.max(F.col("commit_at"))).alias("max_year")).collect()[0].max_year
threshold_year = max_year - 2

# Filter commits from the three most recent calendar years
recent_commits = repo_commits.filter(F.year(F.col("commit_at")) >= threshold_year)

# Group by author and count commits
author_commits = recent_commits.groupBy("author").agg(F.count("*").alias("commit_count"))

# Sort by commit count in descending order and limit to top 10
top_authors = author_commits.orderBy(F.col("commit_count").desc()).limit(10)
