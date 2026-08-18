"""PySpark solution for: Normalization Tradeoffs in Practice
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import col, sum as _sum

# Join transactions and products dataframes
joined_df = transactions.join(products, transactions.product_id == products.product_id)

# Calculate revenue per transaction and group by category
revenue_df = joined_df.groupBy(products.category).agg(_sum(col('quantity') * col('price')).alias('total_revenue'))

# Order results by category
result_df = revenue_df.orderBy(col('category'))
