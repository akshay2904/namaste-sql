"""PySpark solution for: Daily Net Revenue
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter qualifying purchases (positive amounts in date range) and all refunds (negative amounts)
purchases = transactions.filter(
    (F.col("product_id") == 1001) &
    (F.col("total_amount") > 0) &
    (F.col("transaction_date") >= "2026-01-01") &
    (F.col("transaction_date") <= "2026-04-30")
).select("transaction_date", "total_amount")

refunds = transactions.filter(
    (F.col("product_id") == 1001) &
    (F.col("total_amount") < 0)
).select("transaction_date", "total_amount")

# Combine purchases and refunds
relevant = purchases.union(refunds)

# Aggregate net revenue by date and order results
result = relevant.groupBy("transaction_date").agg(
    F.sum("total_amount").alias("net_revenue")
).orderBy("transaction_date")

result.show()
