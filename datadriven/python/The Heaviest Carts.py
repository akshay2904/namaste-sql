"""PySpark solution for: The Heaviest Carts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate total spend for each user
user_spend = transactions.join(users, "user_id").groupBy(users.age_bucket, transactions.user_id).agg(F.sum(transactions.total_amount).alias("total_spent"))

# Rank users by total spend within each age bucket
window_spec = Window.partitionBy(users.age_bucket).orderBy(user_spend.total_spent.desc())
ranked = user_spend.withColumn("spend_rank", F.dense_rank().over(window_spec))

# Select top 3 spenders for each age bucket
result = ranked.filter(ranked.spend_rank <= 3).orderBy(users.age_bucket, user_spend.total_spent.desc(), transactions.user_id)
