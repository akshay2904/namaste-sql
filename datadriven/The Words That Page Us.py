"""PySpark solution for: The Words That Page Us
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Extract year-month from timestamp strings and join on that
result = (
    chat_msgs
    .withColumn("sent_month", F.substring("sent_at", 1, 7))
    .alias("cm")
    .join(
        err_tracks
        .withColumn("first_month", F.substring("first_at", 1, 7))
        .alias("et"),
        F.col("cm.sent_month") == F.col("et.first_month"),
        "inner"
    )
    .filter(
        F.col("cm.content").like("%latency%") |
        F.col("cm.content").like("%down%") |
        F.col("cm.content").like("%back%") |
        F.col("cm.content").like("%pipeline%")
    )
    .select(
        F.col("cm.channel").alias("channel"),
        F.col("cm.content").alias("content"),
        F.col("et.severity").alias("severity")
    )
)

result.show()
