"""PySpark solution for: Inactive vs Suspended Engagement
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join page_views with users on user_id, filter to relevant statuses
result = (
    page_views.join(users, page_views.user_id == users.user_id, "inner")
    .filter(F.col("account_status").isin("inactive", "suspended"))
    .withColumn("view_date", F.to_date(F.col("viewed_at")))
    .groupBy("view_date")
    .agg(
        F.sum(F.when(F.col("account_status") == "inactive", 1).otherwise(0)).alias("inactive_views"),
        F.sum(F.when(F.col("account_status") == "suspended", 1).otherwise(0)).alias("suspended_views")
    )
    .filter(F.col("inactive_views") > F.col("suspended_views"))
    .orderBy("view_date")
)

result.select("view_date", "inactive_views", "suspended_views")
