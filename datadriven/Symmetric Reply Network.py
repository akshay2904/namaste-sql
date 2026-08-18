"""PySpark solution for: Symmetric Reply Network
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

reply_pairs = (
    chat_msgs.filter(F.col("reply_to").isNotNull())
    .select(F.col("sender_id").alias("user_a"), F.col("reply_to").alias("user_b"))
    .unionByName(
        chat_msgs.filter(F.col("reply_to").isNotNull())
        .select(F.col("reply_to").alias("user_a"), F.col("sender_id").alias("user_b"))
    )
)

reply_pairs.show()
