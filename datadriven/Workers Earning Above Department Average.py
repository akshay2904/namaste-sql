"""PySpark solution for: Workers Earning Above Department Average
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Inner-join products to transactions on product_id
joined_df = products.join(transactions, on='product_id', how='inner')

# Per (product_id, product_name), count transactions
transaction_counts = joined_df.groupBy('product_id', 'product_name').count()

# Return product_name and transaction_count
result = transaction_counts.select('product_name', F.col('count').alias('transaction_count'))

# Sort by product_id ascending
result = result.sort('product_id')

result.show()
