"""PySpark solution for: Low-Engagement Sessions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by user_id, calculate average duration, filter for averages below 1000
result = (
    user_sessions
    .groupBy("user_id")
    .agg(F.avg("session_duration_sec").alias("avg_duration"))
    .filter(F.col("avg_duration") < 1000)
    .select("user_id", "avg_duration")
)
