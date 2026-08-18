"""PySpark solution for: The Phantom Readers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter recent page views and count them per user
recent_views = page_views.filter(page_views.viewed_at >= (F.current_date() - 30)).groupBy("user_id").count()

# Identify users with no transactions (anti-join)
no_transactions = users.join(transactions, "user_id", "left_anti")

# Join with user data and filter by view count threshold
target_users = no_transactions.join(recent_views, ["user_id"], "inner").filter(recent_views["count"] >= 5)

# Select and sort the desired output
result = target_users.select("user_id", "username", "email", recent_views["count"].alias("total_views")).orderBy("total_views", ascending=False)
