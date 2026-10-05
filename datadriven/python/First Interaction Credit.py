"""PySpark solution for: First Interaction Credit
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Filter impressions to users who appear in transactions (converted users)
converted_users = ad_impressions.join(transactions.select("user_id").distinct(), "user_id")

# Rank impressions per user by impression_time
window_spec = Window.partitionBy("user_id").orderBy("impression_time")
ranked = converted_users.withColumn("rn", F.row_number().over(window_spec))

# Select the first impression (rn = 1) for each user
result = ranked.filter(F.col("rn") == 1).select("user_id", "ad_campaign", "impression_time")
