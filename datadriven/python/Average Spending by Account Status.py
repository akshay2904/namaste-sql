"""PySpark solution for: Average Spending by Account Status
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Compute total spend per user from transactions
user_totals = (
    transactions
    .groupBy("user_id")
    .agg(F.sum("total_amount").alias("total_spent"))
)

# Join with users on user_id (inner join excludes users with no transactions)
joined = users.join(user_totals, on="user_id", how="inner")

# Group by account_status and compute average total spend
result = (
    joined
    .groupBy("account_status")
    .agg(F.avg("total_spent").alias("avg_total_spending"))
)
