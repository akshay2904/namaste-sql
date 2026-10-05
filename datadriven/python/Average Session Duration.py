"""PySpark solution for: Average Session Duration
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter out null durations and aggregate by user and day
daily_sessions = (
    user_sessions
    .filter(F.col("session_duration_sec").isNotNull())
    .groupBy("user_id", F.to_date("session_start").alias("day"))
    .agg(
        F.sum("session_duration_sec").alias("total_duration"),
        F.count("*").alias("session_count")
    )
)

# Compute average session duration per user
result = (
    daily_sessions
    .groupBy("user_id")
    .agg(
        (F.sum("total_duration") / F.sum("session_count")).alias("avg_session_duration")
    )
    .select("user_id", "avg_session_duration")
)

result.show()
