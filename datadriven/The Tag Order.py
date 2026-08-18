"""PySpark solution for: The Tag Order
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for signup events, normalize tags to lowercase, and order by event_id
result = (
    event_data
    .filter(F.col("event_type") == "signup")
    .select(
        F.col("event_id"),
        F.lower(F.col("tags")).alias("normalized_tags")
    )
    .orderBy("event_id")
)
