"""PySpark solution for: App Stability by Region
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter to only open and crash events
filtered_df = event_data.filter(F.col("event_type").isin("open", "crash"))

# Aggregate by event_timestamp and tags, counting opens and crashes
result_df = filtered_df.groupBy("event_timestamp", "tags").agg(
    F.sum(F.when(F.col("event_type") == "open", 1).otherwise(0)).alias("num_opens"),
    F.sum(F.when(F.col("event_type") == "crash", 1).otherwise(0)).alias("num_crashes")
)

# Calculate crash rate with handling for division by zero (returns None implicitly)
result_df = result_df.withColumn(
    "crash_rate",
    F.when(
        F.col("num_opens") != 0,
        F.round(F.col("num_crashes") * 1.0 / F.col("num_opens"), 4)
    )
)

result_df.select("event_timestamp", "tags", "num_opens", "num_crashes", "crash_rate")
