"""PySpark solution for: Frequent Message Senders
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

chat_msgs = (chat_msgs
             .groupBy("sender_id")
             .agg(F.count("*").alias("msg_count"))
             .filter(F.col("msg_count") > 1)
             .orderBy(F.col("msg_count").desc())
             )
