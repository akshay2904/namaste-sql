"""PySpark solution for: Duplicated User Event Messages
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter rows where topic is 'user-events' and duplicate them with UNION ALL semantic
result = (
    stream_msgs
    .filter(F.col("topic") == "user-events")
    .select("msg_id", "topic", "part_key", "payload", "produced", "consumer")
    .unionAll(
        stream_msgs
        .filter(F.col("topic") == "user-events")
        .select("msg_id", "topic", "part_key", "payload", "produced", "consumer")
    )
    .orderBy("msg_id")
)
