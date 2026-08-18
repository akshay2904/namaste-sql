"""PySpark solution for: Power Users
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join users and user_sessions DataFrames
joined_df = users.join(user_sessions, users.user_id == user_sessions.user_id, "inner")

# Group by user_id and username, count sessions, and filter those with 5 or more sessions
power_users_df = joined_df.groupBy(users.user_id, users.username) \
    .agg(F.count(user_sessions.session_id).alias("session_count")) \
    .filter(F.col("session_count") >= 5) \
    .orderBy(F.col("session_count").desc(), users.username)

# Select only the desired columns
result_df = power_users_df.select(users.username, F.col("session_count"))
