"""PySpark solution for: Super Reviewers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import count

# Filter out rows where reviewer is null
filtered_reviews = code_reviews.filter(code_reviews.reviewer.isNotNull())

# Count reviews per reviewer and filter out those with less than 7 reviews
super_reviewers = filtered_reviews.groupBy("reviewer").agg(count("*").alias("review_count")).filter(count("*") >= 7)

# Sort reviewers by review count in descending order
result = super_reviewers.orderBy("review_count", ascending=False)

result.show()
