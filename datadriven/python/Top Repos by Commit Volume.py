"""PySpark solution for: Top Repos by Commit Volume
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window for ranking
window = Window.orderBy(F.col("commit_count").desc())

# Count commits per repo and rank them
repo_counts = repo_commits.join(ci_builds, "repo_name") \
    .groupBy("repo_name") \
    .agg(F.count("commit_id").alias("commit_count")) \
    .withColumn("rnk", F.rank().over(window))

# Filter top 5 tiers by commit volume
top_tiers = repo_counts.filter(F.col("rnk") <= 5) \
    .select("repo_name", "commit_count")

# Show the result
top_tiers.show()
