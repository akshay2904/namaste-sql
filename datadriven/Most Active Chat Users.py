"""PySpark solution for: Most Active Chat Users
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

chat_msgs_count = chat_msgs.groupBy("sender_id").count().withColumnRenamed("count", "total_messages")

window = Window.orderBy(F.col("total_messages").desc())

result = chat_msgs_count.withColumn("rnk", F.dense_rank().over(window)).orderBy("rnk")

result = result.select("rnk", "sender_id", "total_messages")

result.show()
