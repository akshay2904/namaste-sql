"""PySpark solution for: First Among Equals
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate total transactions per product
product_transactions = transactions.join(products, "product_id") \
    .groupBy("product_name") \
    .agg(F.count("*").alias("order_count"))

# Find the maximum transaction count
max_transactions = product_transactions.agg(F.max("order_count").alias("max_order_count"))

# Filter products with the maximum transaction count
bestsellers = product_transactions.join(max_transactions, "order_count" == F.col("max_order_count")) \
    .select("product_name", "order_count") \
    .orderBy("product_name")
