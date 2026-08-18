"""PySpark solution for: Top Product Categories
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window
window = Window.orderBy(F.col("txn_count").desc())

# Join transactions and products, group by category and count transactions
txn_count_df = transactions.join(products, "product_id") \
    .groupBy("category") \
    .agg(F.count("*").alias("txn_count"))

# Rank categories by transaction count
ranked_df = txn_count_df.withColumn("rnk", F.dense_rank().over(window))

# Filter top 3 categories and order results
result_df = ranked_df.filter(F.col("rnk") <= 3) \
    .orderBy("rnk", F.col("txn_count").desc(), "category")

# Show the result
result_df.show()
