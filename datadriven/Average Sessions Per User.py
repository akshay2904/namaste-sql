"""PySpark solution for: Average Sessions Per User
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Count sessions per user, then average across users
avg_sessions_per_user = (
    user_sessions
    .groupBy("user_id")
    .agg(F.count("*").alias("session_count"))
    .agg(F.avg("session_count").alias("avg_sessions_per_user"))
)

avg_sessions_per_user.show()
