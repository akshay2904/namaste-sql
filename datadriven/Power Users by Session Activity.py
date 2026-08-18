"""PySpark solution for: Power Users by Session Activity
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

power_users = (
    users.join(user_sessions, "user_id", "inner")
    .filter(users.account_status == "active")
    .groupBy("user_id", "username")
    .agg(
        F.count("session_id").alias("session_count"),
        F.sum("pages_viewed").alias("total_pages")
    )
    .filter((F.col("session_count") > 3) & (F.col("total_pages") > 100))
    .orderBy(F.col("total_pages").desc())
)

power_users.show()
