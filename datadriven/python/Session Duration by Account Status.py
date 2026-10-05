"""PySpark solution for: Session Duration by Account Status
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join users and user_sessions on user_id
joined_df = users.join(user_sessions, users.user_id == user_sessions.user_id, "inner")

# Group by account_status and calculate average session duration
result_df = joined_df.groupBy(users.account_status).agg(F.avg(user_sessions.session_duration_sec).alias("avg_session_duration"))

# Sort the result by account_status
result_df = result_df.orderBy(users.account_status)

result_df.show()
