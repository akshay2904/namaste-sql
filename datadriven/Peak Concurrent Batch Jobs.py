"""PySpark solution for: Peak Concurrent Batch Jobs
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create events DataFrame
events = (
    batch_jobs
    .filter(F.col("started").isNotNull() & F.col("ended").isNotNull())
    .select(F.col("started").alias("ts"), F.lit(1).alias("delta"))
    .union(
        batch_jobs
        .filter(F.col("started").isNotNull() & F.col("ended").isNotNull())
        .select(F.col("ended").alias("ts"), F.lit(-1).alias("delta"))
    )
)

# Sort events by timestamp and then by delta (to ensure -1 comes after 1 at same ts)
events = events.orderBy("ts", "delta")

# Calculate running sum of delta
window_spec = Window.orderBy("ts", "delta").rowsBetween(Window.unboundedPreceding, Window.currentRow)
events_with_running_sum = events.select(
    F.sum("delta").over(window_spec).alias("running")
)

# Get the maximum running sum (peak)
peak = events_with_running_sum.agg(F.max("running").alias("peak")).collect()[0]

# Print the result
print(peak.peak)
