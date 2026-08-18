"""PySpark solution for: Commit Royalty
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Filter commits from 2025 and extract month
commits_2025 = repo_commits.filter(
    F.year(F.col("commit_at")) == 2025
).withColumn(
    "month", F.date_format(F.col("commit_at"), "yyyy-MM")
)

# Rank commits by lines added within each month
window_spec = Window.partitionBy("month").orderBy(F.col("added").desc())
ranked = commits_2025.withColumn(
    "rnk", F.dense_rank().over(window_spec)
)

# Filter to top 10 ranks and count per author
top_authors = (
    ranked.filter(F.col("rnk") <= 10)
    .groupBy("author")
    .agg(F.count("*").alias("top10_count"))
    .orderBy(F.col("top10_count").desc(), F.col("author").asc())
    .limit(1)
)

top_authors.show()
