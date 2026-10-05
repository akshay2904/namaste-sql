"""PySpark solution for: Kings of the Aisle
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Join transactions with products, filter for 2026 and aggregate revenue per category-product
product_revenue = (
    transactions.join(products, transactions.product_id == products.product_id)
    .where(F.year(F.col("transaction_date")) == 2026)
    .groupBy(products.category, products.product_name)
    .agg(F.sum("total_amount").alias("total_revenue"))
)

# Rank products within each category by revenue descending (tie-break by product name)
window_spec = Window.partitionBy("category").orderBy(F.col("total_revenue").desc(), "product_name")
ranked = product_revenue.withColumn("rn", F.row_number().over(window_spec))

# Keep only the top product per category and sort by revenue descending
result = (
    ranked.filter(F.col("rn") == 1)
    .select("category", "product_name", "total_revenue")
    .orderBy(F.col("total_revenue").desc())
)
