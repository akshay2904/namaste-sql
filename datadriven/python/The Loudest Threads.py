"""PySpark solution for: The Loudest Threads
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Sort by comments in descending order, then by review_id (implicit in PySpark for tie-breaker)
# Select top 3 after sorting
top_reviews = code_reviews.orderBy(F.col("comments").desc(), F.col("review_id")) \
                           .limit(3)

# Select only the required columns
result = top_reviews.select("repo_name", "author")

result.show()
