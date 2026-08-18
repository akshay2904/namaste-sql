"""PySpark solution for: What Fills the Feed
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

content_items.groupBy("content_type") \
              .agg(F.count("*").alias("cnt")) \
              .orderBy("cnt", ascending=False)
