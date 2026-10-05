"""PySpark solution for: Back Again
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window specification
window_spec = Window.orderBy(F.col("txn_count").desc())

# Create user_spend DataFrame
user_spend = users.join(transactions, users.user_id == transactions.user_id).groupBy(users.username).count().withColumnRenamed("count", "txn_count")

# Create ranked DataFrame
ranked = user_spend.withColumn("rnk", F.dense_rank().over(window_spec))

# Select top 5 tiers
top_tiers = ranked.filter(F.col("rnk") <= 5).select("username", "txn_count", "rnk")

# Show results
top_tiers.show()
