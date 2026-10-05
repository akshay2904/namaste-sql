"""PySpark solution for: Top Product Category by Transactions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate transaction count per category for 2026
transaction_counts_2026 = transactions.join(products, transactions.product_id == products.product_id, "inner") \
    .filter(F.year(transactions.transaction_date) == 2026) \
    .groupBy(products.category) \
    .agg(F.count("*").alias("transaction_count"))

# Find the maximum transaction count
max_transaction_count = transaction_counts_2026.agg(F.max("transaction_count").alias("max_count")).collect()[0].max_count

# Filter categories with the maximum transaction count and sort by category
result = transaction_counts_2026.filter(F.col("transaction_count") == max_transaction_count) \
    .orderBy(F.col("category"))

result.show()
