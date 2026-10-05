"""PySpark solution for: Top Users by Session Time
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join users and user_sessions on user_id
joined_df = users.join(user_sessions, users.user_id == user_sessions.user_id)

# Group by user_id and username, sum session_duration_sec
total_duration_df = joined_df.groupBy(users.user_id, users.username).agg(
    F.sum(user_sessions.session_duration_sec).alias("total_duration")
)

# Order by total_duration in descending order and limit to top 10
result_df = total_duration_df.orderBy(F.col("total_duration").desc()).limit(10)

# Select required columns
output_df = result_df.select("user_id", "username", "total_duration")
