"""PySpark solution for: Total Hours Between Consecutive Events
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window for grouping by event_type and ordering by event_timestamp
window = Window.partitionBy("event_type").orderBy("event_timestamp")

# Calculate the hours difference between consecutive events of the same type
event_gaps = event_data.withColumn(
    "hours_diff",
    (F.unix_timestamp(F.col("event_timestamp")) - 
     F.unix_timestamp(F.lag("event_timestamp").over(window))) / 3600  # Convert seconds to hours
).filter(F.col("hours_diff").isNotNull())

# Group by event_type and sum the hours differences
total_hours_per_type = event_gaps.groupBy("event_type").agg(
    F.sum("hours_diff").alias("total_hours")
)

total_hours_per_type.show()
