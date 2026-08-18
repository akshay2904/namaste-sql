"""PySpark solution for: Engagement Gap
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

result = (
    users
    .join(transactions, users.user_id == transactions.user_id, "left")
    .groupBy(users.user_id, users.username)
    .agg(F.count(transactions.transaction_id).alias("transaction_count"))
    .orderBy("username")
    .select("username", "transaction_count")
)
