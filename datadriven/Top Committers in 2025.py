"""PySpark solution for: Top Committers in 2025
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter commits for 2025 and extract month
repo_commits_2025 = repo_commits.filter(F.year('commit_at') == 2025)
monthly_commits = repo_commits_2025.withColumn('commit_month', F.trunc('commit_at', 'month'))

# Rank commits within each month by lines added
window = Window.partitionBy('commit_month').orderBy(F.col('added').desc())
ranked_commits = monthly_commits.withColumn('month_rank', F.dense_rank().over(window))

# Filter top 10 commits for each month
top10_commits = ranked_commits.filter('month_rank <= 10').select('author', 'commit_month')

# Count top 10 appearances for each author
author_counts = top10_commits.groupBy('author').count()

# Get author with highest count, breaking ties alphabetically
result = author_counts.orderBy('count', 'author').limit(1)
