"""PySpark solution for: Low-Volume Stream Topics
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by topic, count messages, filter fewer than 11, and order
result = (
    stream_msgs
    .groupBy("topic")
    .agg(F.count("*").alias("msg_count"))
    .filter(F.col("msg_count") < 11)
    .orderBy(F.col("msg_count").asc(), F.col("topic").asc())
)
