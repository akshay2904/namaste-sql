"""PySpark solution for: Top Category by User Segment
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.partitionBy("account_status").orderBy(F.col("purchase_count").desc())

# Calculate purchase counts and rank categories by count within each account status
ranked_df = transactions.join(users, transactions.user_id == users.user_id) \
    .join(products, transactions.product_id == products.product_id) \
    .groupBy(users.account_status, products.category) \
    .agg(F.count("*").alias("purchase_count")) \
    .withColumn("rk", F.rank().over(window_spec)) \
    .filter(F.col("rk") == 1) \
    .select("account_status", "category", "purchase_count") \
    .orderBy("account_status", "category")

# Display the result
ranked_df.show()
