"""PySpark solution for: The Space Between
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter out null user_ids
filtered_events = event_data.filter(F.col("user_id").isNotNull())

# Define window spec partitioned by user_id, ordered by timestamp and event_id
window_spec = Window.partitionBy("user_id").orderBy("event_timestamp", "event_id")

# Add lag column to get previous timestamp
events_with_lag = filtered_events.withColumn(
    "prev_timestamp",
    F.lag("event_timestamp").over(window_spec)
)

# Filter out rows without previous timestamp, compute average gap, group by user_id
# event_timestamp is string, so convert to Unix timestamp for difference calculation
result = (
    events_with_lag
    .filter(F.col("prev_timestamp").isNotNull())
    .withColumn("timestamp_diff", 
                F.unix_timestamp("event_timestamp", "yyyy-MM-dd HH:mm:ss") - 
                F.unix_timestamp("prev_timestamp", "yyyy-MM-dd HH:mm:ss"))
    .groupBy("user_id")
    .agg(F.avg("timestamp_diff").alias("avg_progression_seconds"))
    .orderBy("user_id")
)

result.select("user_id", "avg_progression_seconds")
