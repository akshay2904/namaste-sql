"""PySpark solution for: Days with More Edited Than Unedited Messages
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Identify dates where edited messages outnumber unedited messages
qualifying_days = (
    chat_msgs
    .withColumn("msg_date", F.to_date("sent_at"))
    .groupBy("msg_date")
    .agg(
        F.sum(F.when(F.col("edited") == 1, 1).otherwise(0)).alias("edited_count"),
        F.sum(F.when(F.col("edited") == 0, 1).otherwise(0)).alias("unedited_count")
    )
    .filter(F.col("edited_count") > F.col("unedited_count"))
    .select("msg_date")
)

# Join back to original messages and order the results
result = (
    chat_msgs
    .withColumn("msg_date", F.to_date("sent_at"))
    .join(qualifying_days, "msg_date", "inner")
    .drop("msg_date")
    .orderBy("sent_at", "msg_id")
)

result.show()
