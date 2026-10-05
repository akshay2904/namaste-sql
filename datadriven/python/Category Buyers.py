"""PySpark solution for: Category Buyers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join products with transactions on product_id
joined_df = products.join(transactions, products.product_id == transactions.product_id)

# Group by category, compute unique buyers and total revenue
result_df = (
    joined_df
    .groupBy(products.category)
    .agg(
        F.countDistinct(transactions.user_id).alias("unique_buyers"),
        F.sum(transactions.total_amount).alias("total_revenue")
    )
    # Only include categories with at least 3 unique buyers
    .filter(F.col("unique_buyers") >= 3)
    # Sort by total revenue descending
    .orderBy(F.col("total_revenue").desc())
)

result_df.select("category", "unique_buyers", "total_revenue").show()
