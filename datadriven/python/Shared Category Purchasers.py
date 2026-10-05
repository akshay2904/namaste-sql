"""PySpark solution for: Shared Category Purchasers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter transactions for unique user pairs per product category
transactions_filtered = transactions.alias("t1").join(
    transactions.alias("t2"), 
    (F.col("t1.user_id") < F.col("t2.user_id")) & 
    (F.col("t1.product_id") == F.col("t2.product_id")), 
    how="inner"
)

# Join with products to get category and filter pairs in same category
transactions_with_category = transactions_filtered.join(
    products.alias("p"), 
    F.col("t1.product_id") == F.col("p.product_id"), 
    how="inner"
).join(
    products.alias("p2"), 
    (F.col("t2.product_id") == F.col("p2.product_id")) & 
    (F.col("p.category") == F.col("p2.category")), 
    how="inner"
)

# Group by category and user pair, count shared products
user_pairs_shared = transactions_with_category.groupBy(
    F.col("p.category"), 
    F.col("t1.user_id").alias("user1"), 
    F.col("t2.user_id").alias("user2")
).agg(
    F.count("*").alias("shared_categories")
)

# Order by shared categories in descending order and select required columns
final_output = user_pairs_shared.select(
    "category", "user1", "user2", "shared_categories"
).orderBy(F.col("shared_categories").desc())
