"""PySpark solution for: Fault Lines
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join event data with users, filter for relevant event types
result = (
    event_data
    .join(users, event_data.user_id == users.user_id)
    .filter(F.col("event_type").isin("open", "error", "crash"))
    .groupBy(
        F.substring("event_timestamp", 1, 10).alias("event_day"),
        F.col("age_bucket").alias("region")
    )
    .agg(
        (
            F.sum(F.when(F.col("event_type").isin("error", "crash"), 1).otherwise(0)).cast("double")
            / F.sum(F.when(F.col("event_type") == "open", 1).otherwise(0))
        ).alias("error_rate")
    )
)

result.select("event_day", "region", "error_rate")
