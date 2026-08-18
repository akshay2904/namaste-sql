"""PySpark solution for: Deep Pockets
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter transactions for March 2026 and group by user_id to sum total_amount
march_transactions = transactions.filter(
    (transactions.transaction_date >= "2026-03-01") & 
    (transactions.transaction_date < "2026-04-01")
).groupBy("user_id").agg(
    F.sum("total_amount").alias("total_revenue")
).orderBy(F.col("total_revenue").desc())
