"""PySpark solution for: The Ninety-Day Comeback
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get first session date per user
first_sessions = (
    user_sessions
    .select("user_id", F.to_date("session_start").alias("session_date"))
    .groupBy("user_id")
    .agg(F.min("session_date").alias("first_date"))
)

# Join to find retained users (those with a session after first within 90 days)
joined = (
    user_sessions
    .select("user_id", F.to_date("session_start").alias("session_date"))
    .join(first_sessions, "user_id")
    .filter(
        (F.col("session_date") > F.col("first_date")) &
        (F.col("session_date") <= F.date_add(F.col("first_date"), 90))
    )
    .select("user_id")
    .distinct()
)

# Calculate retention rate
total_users = first_sessions.count()
retained_users = joined.count()
retention_rate = retained_users / total_users if total_users > 0 else 0.0

# Return as DataFrame
result = spark.createDataFrame([(retention_rate,)], ["retention_rate"])
