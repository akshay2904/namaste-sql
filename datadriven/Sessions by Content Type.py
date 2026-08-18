"""PySpark solution for: Sessions by Content Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

content_items \
  .groupBy("content_type") \
  .agg(F.count("*").alias("session_count")) \
  .orderBy(F.col("session_count").desc(), F.col("content_type").asc()) \
  .show()
