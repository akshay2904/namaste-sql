"""PySpark solution for: Repository Commit Ranking
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate total lines added per repo and rank them
repo_ranks = (
    repo_commits
    .groupBy("repo_name")
    .agg(F.sum("added").alias("total_added"))
    .withColumn("rank", F.dense_rank().over(Window.orderBy(F.col("total_added").desc())))
    .orderBy("rank")
)

# Select and display the desired columns
repo_ranks.select("repo_name", "total_added", "rank").show()
