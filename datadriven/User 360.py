"""PySpark solution for: User 360
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Aggregate transactions and user_sessions by user_id
transactions_agg = transactions.groupBy("user_id").agg(F.count("*").alias("txn_count"))
user_sessions_agg = user_sessions.groupBy("user_id").agg(F.count("*").alias("session_count"))

# Left join with users table
result = (
    users
    .join(transactions_agg, users.user_id == transactions_agg.user_id, "left")
    .join(user_sessions_agg, users.user_id == user_sessions_agg.user_id, "left")
    .select(
        users.username,
        F.coalesce(transactions_agg.txn_count, F.lit(0)).alias("transaction_count"),
        F.coalesce(user_sessions_agg.session_count, F.lit(0)).alias("session_count")
    )
)
