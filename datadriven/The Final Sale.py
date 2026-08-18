"""PySpark solution for: The Final Sale
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window spec to rank transactions by date and id
window_spec = Window.partitionBy('product_id').orderBy(F.col('transaction_date').desc(), F.col('transaction_id').desc())

# Rank transactions
ranked_transactions = transactions.withColumn('rn', F.row_number().over(window_spec))

# Filter to get the latest transaction for each product
latest_transactions = ranked_transactions.filter(F.col('rn') == 1).drop('rn')

# Join with products and select required columns
result = products.join(latest_transactions, 'product_id').select(
    'product_name', 'category', 'total_amount', 'transaction_date'
).withColumnRenamed('total_amount', 'latest_sale_amount').withColumnRenamed('transaction_date', 'last_sale_date')

# Sort by product name and id
result = result.orderBy('product_name', 'product_id')
