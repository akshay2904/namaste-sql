"""PySpark solution for: The Loudest Rooms
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

# Join ad_impressions with chat_msgs on user_id = sender_id
result = (
    ad_impressions.join(chat_msgs, ad_impressions.user_id == chat_msgs.sender_id)
    .groupBy(chat_msgs["channel"].alias("channel"))
    .agg(F.count("*").alias("impression_count"))
    .orderBy(F.desc("impression_count"), F.asc("channel"))
)

result.select("channel", "impression_count").show()
