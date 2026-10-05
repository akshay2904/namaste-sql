"""PySpark solution for: The Regulars
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Find users active in at least 3 distinct calendar months (YYYY-MM)
result = (
    user_sessions.groupBy("user_id")
    .agg(
        F.countDistinct(F.date_format(F.col("session_start"), "yyyy-MM")).alias(
            "month_count"
        )
    )
    .filter(F.col("month_count") >= 3)
    .select("user_id")
)
