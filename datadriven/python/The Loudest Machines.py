"""PySpark solution for: The Loudest Machines
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

server_logs \
    .filter(F.year(F.to_timestamp("log_timestamp")) == 2026) \
    .groupBy("server_name") \
    .agg(F.count("*").alias("log_count")) \
    .orderBy(F.col("log_count").desc(), F.col("server_name").asc()) \
    .select("server_name", "log_count") \
    .show()
