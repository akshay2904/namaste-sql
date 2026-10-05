"""PySpark solution for: Pages Viewed by Session Duration
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define bucketing logic using when-otherwise chain
bucketing_condition = (
    F.when(F.col("session_duration_sec") < 60, "under_1min")
    .when(F.col("session_duration_sec") < 300, "1_to_5min")
    .when(F.col("session_duration_sec") < 900, "5_to_15min")
    .when(F.col("session_duration_sec") < 1800, "15_to_30min")
    .otherwise("over_30min")
)

# Apply bucketing, aggregate, and sort
result = (
    user_sessions
    .withColumn("duration_bucket", bucketing_condition)
    .groupBy("duration_bucket")
    .agg(
        F.count("*").alias("session_count"),
        F.avg("pages_viewed").alias("avg_pages")
    )
    .orderBy(F.col("avg_pages").desc(), F.col("duration_bucket"))
)

# Show the result (assuming you want to display or collect it)
result.show()
