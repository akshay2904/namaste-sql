"""PySpark solution for: Custom Message Type Counts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    chat_msgs
    .filter(
        (F.col("msg_type").isin("text", "image") == False) & 
        F.col("reply_to").isNotNull()
    )
    .groupBy(
        F.col("reply_to").alias("recipient_id"),
        "msg_type"
    )
    .agg(F.count("*").alias("msg_count"))
)

result = result.select("recipient_id", "msg_type", "msg_count")
