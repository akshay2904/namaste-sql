"""PySpark solution for: Inactive Users in Date Range
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter sessions in June 1 - July 2, 2026 window (using string literals to avoid parsing issues)
user_sessions_filtered = user_sessions.filter(
    (F.col("session_start") >= "2026-06-01") &
    (F.col("session_start") < "2026-07-02")
)

# Left join users with filtered sessions, keep users with no matching sessions
result = users.join(
    user_sessions_filtered,
    on="user_id",
    how="left_outer"
).filter(
    F.col("session_id").isNull()
).select(
    "username"
).orderBy("username")

result.show()
