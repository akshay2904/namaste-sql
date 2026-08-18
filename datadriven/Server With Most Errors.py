"""PySpark solution for: Server With Most Errors
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

server_logs \
  .filter(F.col("log_level") == "ERROR") \
  .groupBy("server_name") \
  .agg(F.count("*").alias("error_count")) \
  .orderBy(F.col("error_count").desc()) \
  .limit(1) \
  .show()
