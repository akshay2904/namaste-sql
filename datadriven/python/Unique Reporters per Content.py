"""PySpark solution for: Unique Reporters per Content
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

chat_msgs = chat_msgs.filter(F.col('reply_to').isNotNull()) \
    .groupBy('reply_to') \
    .agg(F.countDistinct(F.concat(F.col('sender_id'), F.lit('-'), F.col('channel'))).alias('reporter_count')) \
    .select(F.col('reply_to').alias('content_id'), F.col('reporter_count'))
