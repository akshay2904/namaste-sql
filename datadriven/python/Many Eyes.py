"""PySpark solution for: Many Eyes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

result = code_reviews \
    .withColumn("review_year", F.year("opened_at")) \
    .groupBy("repo_name", "review_year") \
    .agg(F.countDistinct("reviewer").alias("reviewer_count")) \
    .orderBy("reviewer_count", ascending=False)
