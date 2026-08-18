"""PySpark solution for: The Loudest Voices
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate messages sent by each user
user_msgs_sent = chat_msgs.select("sender_id").withColumnRenamed("sender_id", "user_id").groupBy("user_id").agg(F.count("*").alias("msg_count"))

# Calculate messages replied to each user
user_msgs_replied = chat_msgs.filter(F.col("reply_to").isNotNull()).select("reply_to").withColumnRenamed("reply_to", "user_id").groupBy("user_id").agg(F.count("*").alias("msg_count"))

# Combine sent and replied messages
user_msgs = user_msgs_sent.unionByName(user_msgs_replied)

# Aggregate total messages per user and rank
leaderboard = user_msgs.groupBy("user_id").agg(F.sum("msg_count").alias("total_messages")).orderBy(F.col("total_messages").desc()).limit(10)

leaderboard.show()
