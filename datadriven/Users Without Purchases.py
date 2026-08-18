"""PySpark solution for: Users Without Purchases
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Left join users with transactions and filter for users with no corresponding transactions
result = (
    users.join(transactions, on="user_id", how="left")
    .filter(F.col("transaction_id").isNull())
    .agg(F.count("*").alias("users_without_purchases"))
)
