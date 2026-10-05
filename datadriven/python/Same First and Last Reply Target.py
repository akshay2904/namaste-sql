"""PySpark solution for: Same First and Last Reply Target
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window partition
window = Window.partitionBy("sender_id", "channel", F.substring(F.col("sent_at"), 1, 10)).orderBy("sent_at")

# Calculate first and last reply_to values per partition
chat_msgs_with_first_last = chat_msgs.filter(F.col("reply_to").isNotNull()) \
    .withColumn("msg_date", F.substring(F.col("sent_at"), 1, 10)) \
    .withColumn("first_reply", F.first(F.col("reply_to")).over(window)) \
    .withColumn("last_reply", F.last(F.col("reply_to")).over(window.rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)))

# Filter where first and last reply_to match and select distinct results
result = chat_msgs_with_first_last.filter(F.col("first_reply") == F.col("last_reply")) \
    .select(F.col("sender_id"), F.col("reply_to"), F.col("msg_date")).distinct() \
    .orderBy("sender_id", "msg_date")

result.show()
