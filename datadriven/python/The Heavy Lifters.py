"""PySpark solution for: The Heavy Lifters
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join transactions and products
joined_df = transactions.join(products, transactions.product_id == products.product_id)

# Group by category and calculate bulk revenue vs total revenue
result = (
    joined_df.groupBy("category")
    .agg(
        F.sum(F.when(F.col("quantity") >= 3, F.col("total_amount")).otherwise(0)).alias("bulk_revenue"),
        F.sum("total_amount").alias("total_revenue")
    )
    .filter(F.col("bulk_revenue") > 0.5 * F.col("total_revenue"))
    .select("category")
    .orderBy("category")
)

result.show()
