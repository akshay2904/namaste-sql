"""PySpark solution for: The Ones That Move
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate product revenue
product_revenue = order_items.join(products, order_items.product_id == products.product_id) \
    .groupBy(products.category, products.product_name) \
    .agg(F.sum(order_items.quantity * order_items.unit_price).alias('revenue'))

# Rank products by revenue within each category
window = Window.partitionBy('category').orderBy(F.col('revenue').desc())
ranked = product_revenue.withColumn('revenue_rank', F.dense_rank().over(window))

# Select top 3 products per category
top_products = ranked.filter(F.col('revenue_rank') <= 3) \
    .select('category', 'product_name', 'revenue', 'revenue_rank') \
    .orderBy('category', 'revenue_rank', 'product_name')

# Display results
top_products.show()
