"""PySpark solution for: Busy Authors
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Normalize author and filter out null/blank authors
df = repo_commits.filter(
    F.col("author").isNotNull() & (F.trim(F.col("author")) != "")
).withColumn("author", F.lower(F.col("author")))

# Count distinct repos per author, keep only those with >1 repo
result = (
    df.groupBy("author")
    .agg(F.countDistinct("repo_name").alias("repo_count"))
    .filter(F.col("repo_count") > 1)
    .orderBy(F.col("repo_count").desc(), F.col("author").asc())
)

result.show()
