"""PySpark solution for: The Biggest Fish
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate total spend per category and user
category_spend = transactions.join(products, "product_id").groupBy(products.category, transactions.user_id).agg(F.sum(transactions.total_amount).alias("total_spent"))

# Rank users by total spend within each category
window = Window.partitionBy("category").orderBy(F.col("total_spent").desc())
ranked = category_spend.withColumn("spend_rank", F.rank().over(window))

# Select users with the highest spend in each category
result = ranked.filter(F.col("spend_rank") == 1).select("category", "user_id", "total_spent").orderBy("category", "user_id")
