"""PySpark solution for: Spending by Account Status
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Perform LEFT JOIN between users and transactions
joined_df = users.join(transactions, users.user_id == transactions.user_id, "left")

# Group by account_status and aggregate
result_df = joined_df.groupBy(users.account_status) \
    .agg(
        F.count(transactions.transaction_id).alias("transaction_count"),
        F.countDistinct(users.user_id).alias("user_count"),
        F.sum(transactions.total_amount).alias("total_revenue")
    ) \
    .filter(F.col("transaction_count") >= 5) \
    .orderBy(F.col("total_revenue").desc())

# Display the result
result_df.select("account_status", "transaction_count", "user_count", "total_revenue").show()
