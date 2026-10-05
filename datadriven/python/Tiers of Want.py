"""PySpark solution for: Tiers of Want
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join transactions with products on product_id
joined = transactions.join(products, "product_id")

# Calculate basket metrics per user per category
user_baskets = joined.groupBy("user_id", "category").agg(
    F.sum("total_amount").alias("total_sales"),
    F.count("*").alias("txn_count"),
    (F.sum("total_amount") / F.count("*")).alias("basket_size"),
    F.when((F.sum("total_amount") / F.count("*")) > 500, "High")
     .when((F.sum("total_amount") / F.count("*")) >= 200, "Medium")
     .otherwise("Low").alias("segment")
)

# Aggregate by category and segment, calculate required metrics
result = user_baskets.groupBy("category", "segment").agg(
    F.count("user_id").alias("unique_users"),
    F.sum("txn_count").alias("total_transactions"),
    F.sum("total_sales").alias("total_sales"),
    F.avg("basket_size").alias("avg_basket_size")
)

# Sort and select final columns (assuming sorting is needed for the output, as in the SQL example)
result = result.select("category", "segment", "unique_users", "total_transactions", "total_sales", "avg_basket_size")
