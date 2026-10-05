"""PySpark solution for: New vs Returning User Share
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate first month for each user
user_first_month = event_data.groupBy("user_id").agg(
    F.min(F.date_trunc("month", "event_timestamp")).alias("first_month")
)

# Calculate active users for each month
monthly_active = event_data.select(
    "user_id",
    F.date_trunc("month", "event_timestamp").alias("month")
).distinct()

# Join and calculate ratios
result = monthly_active.join(user_first_month, "user_id").groupBy("month").agg(
    F.sum(F.when(F.col("first_month") == F.col("month"), 1).otherwise(0)).alias("new_users"),
    F.sum(F.when(F.col("first_month") < F.col("month"), 1).otherwise(0)).alias("returning_users"),
    F.count("*").alias("total_users")
).select(
    "month",
    (F.col("new_users") / F.col("total_users")).alias("new_user_ratio"),
    (F.col("returning_users") / F.col("total_users")).alias("returning_user_ratio")
).orderBy("month")

result.show()
