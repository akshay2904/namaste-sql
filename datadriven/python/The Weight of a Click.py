"""PySpark solution for: The Weight of a Click
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter to the four target event types and count distinct users per event type
counts = (
    event_data
    .filter(F.col("event_type").isin("page_view", "search", "checkout_start", "purchase"))
    .groupBy("event_type")
    .agg(F.countDistinct("user_id").alias("unique_users"))
)

# Compute total unique users across all four events
total_users = counts.agg(F.sum("unique_users").alias("total")).collect()[0]["total"]

# Add percentage column and sort by unique_users descending, then event_type ascending
result = (
    counts
    .withColumn("pct_of_engaged", F.round(F.col("unique_users") * 100.0 / total_users, 1))
    .orderBy(F.desc("unique_users"), F.col("event_type"))
)

result.select("event_type", "unique_users", "pct_of_engaged")
