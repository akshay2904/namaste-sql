"""PySpark solution for: Average Review Comments by Author
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Aggregate average comments per author from code_reviews
review_stats = code_reviews.groupBy("author").agg(F.avg("comments").alias("avg_comments"))

# Aggregate earliest commit per author from repo_commits
commit_stats = repo_commits.groupBy("author").agg(F.min("commit_at").alias("earliest_commit"))

# Join on author and sort by earliest commit ascending, then author ascending
result = review_stats.join(commit_stats, on="author", how="inner") \
    .select("author", "avg_comments", "earliest_commit") \
    .orderBy(F.col("earliest_commit").asc(), F.col("author").asc())

result.show()
