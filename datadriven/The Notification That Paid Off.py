"""PySpark solution for: The Notification That Paid Off
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql import Window

# Find each user's first transaction date
first_txn = transactions.groupBy("user_id").agg(F.min("transaction_date").alias("first_date"))

# Get products purchased on each user's first day
first_day_products = transactions.join(first_txn, ["user_id"]) \
    .filter(F.col("transaction_date") == F.col("first_date")) \
    .select("user_id", "product_id").distinct()

# Get products purchased after the first day + 1 (post-campaign)
post_campaign = transactions.join(first_txn, ["user_id"]) \
    .filter(F.datediff(F.col("transaction_date"), F.col("first_date")) > 1) \
    .select("user_id", "product_id").distinct()

# Count users who bought products NOT in their first-day products
result = post_campaign.join(
    first_day_products,
    ["user_id", "product_id"],
    "left_anti"
).select("user_id").distinct().count()

# Return as DataFrame with expected column name
result_df = spark.createDataFrame([(result,)], ["user_count"])
result_df.show()
