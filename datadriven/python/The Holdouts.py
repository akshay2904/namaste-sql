"""PySpark solution for: The Holdouts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

basic_users = push_notifs.filter(F.col("platform") == "basic").select("user_id")
premium_users = push_notifs.filter(F.col("platform") == "premium").select("user_id")

result = basic_users.join(premium_users, on="user_id", how="left_anti")
result.select("user_id").distinct().show()
