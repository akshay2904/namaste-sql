"""PySpark solution for: Top Buyers of Premium Products
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the ranking window
window = Window.orderBy(F.col("rating").desc())

# Rank products by rating and filter top 10
top_rated = products.filter(F.col("rating").isNotNull()) \
    .withColumn("rnk", F.dense_rank().over(window)) \
    .filter(F.col("rnk") <= 10) \
    .select("product_id")  # Only need product_id for join

# Join with order_items and aggregate purchases per user
user_purchases = order_items.join(top_rated, "product_id") \
    .groupBy("user_id") \
    .agg(F.countDistinct("item_id").alias("purchase_count")) \
    .orderBy(F.col("purchase_count").desc()) \
    .limit(10)

# Display the result
user_purchases.show()
