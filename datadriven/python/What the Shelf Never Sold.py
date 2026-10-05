"""PySpark solution for: What the Shelf Never Sold
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Perform LEFT JOIN and GroupBy operations with aggregation
revenue_report = (
    products
    .join(transactions, "product_id", "left")
    .groupBy("product_id", "product_name")
    .agg(F.round(F.coalesce(F.sum("total_amount"), F.lit(0)), 2).alias("total_revenue"))
    .orderBy("product_id")
)

# Show the result
revenue_report.show()
