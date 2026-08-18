"""PySpark solution for: The Vote Tally
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    transactions
    .filter(F.col("product_id") == 1001)
    .groupBy("transaction_date")
    .agg(F.sum("total_amount").alias("net_revenue"))
    .orderBy("transaction_date")
)
