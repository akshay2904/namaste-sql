"""PySpark solution for: Active Duo
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Find users who have records in both transactions and user_sessions
result = (
    users.join(transactions, on="user_id", how="inner")
    .join(user_sessions, on="user_id", how="inner")
    .select("username")
    .distinct()
    .orderBy("username")
)
