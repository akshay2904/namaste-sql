"""PySpark solution for: Best in Class
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Calculate revenue per category and product
product_revenue = transactions \
    .join(products, transactions.product_id == products.product_id) \
    .groupBy(products.category, products.product_name) \
    .agg(F.sum(transactions.total_amount).alias("product_revenue")) \
    .select(
        F.col("category").alias("category"),
        F.col("product_name").alias("product_name"),
        F.col("product_revenue").alias("product_revenue")
    )

# Rank products within each category by revenue
window_spec = Window.partitionBy("category").orderBy(F.col("product_revenue").desc())
ranked = product_revenue.withColumn("category_rank", F.rank().over(window_spec))

# Filter top-ranked product per category and sort by revenue descending
result = ranked \
    .filter(F.col("category_rank") == 1) \
    .select("category", "product_name", "product_revenue") \
    .orderBy(F.col("product_revenue").desc())

result.show(truncate=False)
