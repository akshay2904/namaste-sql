"""PySpark solution for: New User Purchases
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

total_revenue = (
    transactions
    .join(users, "user_id")
    .filter(F.year(users.signup_date) == 2026)
    .agg(F.sum(transactions.total_amount).alias("total_revenue"))
)

total_revenue.show()
