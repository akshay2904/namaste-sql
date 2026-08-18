"""PySpark solution for: Top Revenue Products H1
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter transactions for January through June
filtered_transactions = transactions.filter(F.month('transaction_date').between(1, 6))

# Calculate total revenue for each product
product_revenue = filtered_transactions.groupBy('product_id').agg(F.sum('total_amount').alias('total_revenue'))

# Rank products by total revenue
window = Window.orderBy(F.col('total_revenue').desc())
ranked_products = product_revenue.withColumn('rnk', F.dense_rank().over(window))

# Get top 5 products
top_products = ranked_products.filter(F.col('rnk') <= 5).orderBy('total_revenue', ascending=False)

# Drop rnk column
result = top_products.drop('rnk')

# Show result
result.show()
