"""PySpark solution for: Across the Aisles
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join transactions and products
joined_df = transactions.join(products, transactions.product_id == products.product_id)

# Group by user_id and count distinct categories
category_counts = joined_df.groupBy('user_id') \
    .agg(F.countDistinct('category').alias('category_count')) \
    .filter(F.col('category_count') > 1) \
    .orderBy(F.col('category_count').desc())

# Select the desired columns
result = category_counts.select('user_id', 'category_count')
