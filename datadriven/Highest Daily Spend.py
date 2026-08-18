"""PySpark solution for: Highest Daily Spend
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Join users and transactions, filter date range
joined_df = users.join(transactions, users.user_id == transactions.user_id, "inner") \
    .filter((F.col("transaction_date") >= "2026-03-01") & (F.col("transaction_date") <= "2026-06-01"))

# Aggregate daily spend per user
daily_spend = joined_df.groupBy("username", "transaction_date") \
    .agg(F.sum("total_amount").alias("total_daily_spend"))

# Rank users by daily spend per date
window_spec = Window.partitionBy("transaction_date").orderBy(F.col("total_daily_spend").desc())
ranked = daily_spend.withColumn("rnk", F.dense_rank().over(window_spec))

# Filter for top spenders and order results
result = ranked.filter(F.col("rnk") == 1) \
    .select("username", "total_daily_spend", "transaction_date") \
    .orderBy("transaction_date", "username")

result.show()
