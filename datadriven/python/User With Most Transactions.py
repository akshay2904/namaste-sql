"""PySpark solution for: User With Most Transactions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate transaction count per user
txn_counts = transactions.groupBy("user_id").count().withColumnRenamed("count", "txn_count")

# Find the maximum transaction count
max_txn_count = txn_counts.select(F.max("txn_count").alias("max_count")).collect()[0].max_count

# Filter users with the maximum transaction count and join with users table
top_users = txn_counts.filter(F.col("txn_count") == max_txn_count).join(users, "user_id", "inner")

# Select usernames of top users
result = top_users.select("username")
