"""PySpark solution for: Two-Way Street
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter to only replies and count distinct undirected user pairs
result = (chat_msgs
    .filter(F.col("reply_to").isNotNull())
    .select(
        F.countDistinct(
            F.array_sort(F.array(F.col("sender_id"), F.col("reply_to")))
        ).alias("conversation_count")
    )
)
result.show()
