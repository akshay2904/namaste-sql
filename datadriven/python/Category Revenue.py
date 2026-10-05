"""PySpark solution for: Category Revenue
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join products and transactions on product_id
joined_df = products.join(transactions, products.product_id == transactions.product_id)

# Group by category, compute aggregates, filter, and sort
result = (
    joined_df.groupBy("category")
    .agg(
        F.sum("total_amount").alias("total_revenue"),
        F.count("*").alias("transaction_count"),
        F.avg("total_amount").alias("avg_transaction_size")
    )
    .filter(F.col("total_revenue") >= 500)
    .orderBy(F.col("total_revenue").desc())
)

result.show()
