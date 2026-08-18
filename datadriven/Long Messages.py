"""PySpark solution for: Long Messages
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter out null/empty messages, keep messages longer than 10 characters
result = (
    repo_commits
    .filter(F.col("message").isNotNull() & (F.trim(F.col("message")) != ""))
    .withColumn("message_length", F.length(F.col("message")))
    .filter(F.col("message_length") > 10)
    .select("author", "message", "message_length")
    .orderBy(F.col("message_length").desc(), F.col("author").asc(), F.col("message").asc())
)

result.show(truncate=False)
