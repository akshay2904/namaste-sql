"""PySpark solution for: Daily Session and User Counts
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

# Convert session_start to date and aggregate
result = (
    user_sessions
    .withColumn("session_date", F.to_date("session_start"))
    .groupBy("session_date")
    .agg(
        F.count("*").alias("total_sessions"),
        F.countDistinct("user_id").alias("unique_users")
    )
    .orderBy("session_date")
)
