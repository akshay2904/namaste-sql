"""PySpark solution for: Six Degrees
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

edges = chat_msgs.filter((chat_msgs.reply_to.isNotNull()) & (chat_msgs.reply_to != chat_msgs.sender_id)) \
    .select(chat_msgs.sender_id.alias("user_id"), chat_msgs.reply_to.alias("connected_to")) \
    .unionByName(chat_msgs.filter((chat_msgs.reply_to.isNotNull()) & (chat_msgs.reply_to != chat_msgs.sender_id)) \
                  .select(chat_msgs.reply_to.alias("user_id"), chat_msgs.sender_id.alias("connected_to")))

total_users = chat_msgs.select(chat_msgs.sender_id.alias("u")).unionByName(chat_msgs.filter(chat_msgs.reply_to.isNotNull()).select(chat_msgs.reply_to.alias("u"))) \
    .agg(F.countDistinct("u").alias("total_users"))

result = edges.groupBy("user_id") \
    .agg(F.countDistinct("connected_to").alias("unique_connections")) \
    .crossJoin(total_users) \
    .withColumn("connection_score", F.round(F.col("unique_connections") * 100.0 / F.col("total_users"), 4)) \
    .select("user_id", "unique_connections", "connection_score") \
    .orderBy(F.col("connection_score").desc(), F.col("user_id"))
