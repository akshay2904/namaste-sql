"""PySpark solution for: Minimum Parallel Workers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Deduplicate jobs with valid start and end times
distinct_jobs = (
    batch_jobs
    .filter(F.col("started").isNotNull() & F.col("ended").isNotNull())
    .select("job_id", "started", "ended")
    .distinct()
)

# Create start events (+1) and end events (-1)
start_events = distinct_jobs.select(
    F.col("started").alias("event_time"),
    F.lit(1).alias("delta")
)

end_events = distinct_jobs.select(
    F.col("ended").alias("event_time"),
    F.lit(-1).alias("delta")
)

events = start_events.union(end_events)

# Compute running count of concurrent jobs
window_spec = Window.orderBy(F.col("event_time"), F.col("delta").desc())
running = events.withColumn(
    "concurrent",
    F.sum("delta").over(window_spec)
)

# Get peak concurrency
min_workers = running.agg(F.max("concurrent").alias("min_workers"))
