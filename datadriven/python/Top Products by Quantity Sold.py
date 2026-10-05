"""PySpark solution for: Top Products by Quantity Sold
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter transactions for 2026 and group by product_id
transactions_2026 = transactions.filter(F.year(F.col('transaction_date')) == 2026)

# Calculate total quantity sold for each product and order by total_quantity DESC
result = transactions_2026.groupBy('product_id').agg(F.sum('quantity').alias('total_quantity')).orderBy(F.col('total_quantity').desc())

result.show()
