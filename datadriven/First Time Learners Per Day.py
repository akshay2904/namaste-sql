"""PySpark solution for: First Time Learners Per Day
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by user_id to get each user's first session date
first_sessions = (
    user_sessions
    .withColumn("session_date", F.to_date("session_start"))
    .groupBy("user_id")
    .agg(F.min("session_date").alias("first_session_date"))
)

# Count new users per first session date
result = (
    first_sessions
    .groupBy("first_session_date")
    .agg(F.count("*").alias("new_user_count"))
    .orderBy("first_session_date")
)
