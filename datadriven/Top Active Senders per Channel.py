"""PySpark solution for: Top Active Senders per Channel
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

msg_counts = chat_msgs.groupBy('channel', 'sender_id').count().withColumnRenamed('count', 'msg_count')

window = Window.partitionBy('channel').orderBy(F.col('msg_count').desc())
ranked = msg_counts.withColumn('rnk', F.dense_rank().over(window))

result = ranked.filter(F.col('rnk') <= 3).select('channel', 'sender_id', 'msg_count').orderBy('channel', F.col('msg_count').desc(), 'sender_id')
