"""PySpark solution for: Retried Failed API Calls
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window to look back at previous calls
window_spec = Window.partitionBy("user_id", "endpoint").orderBy("call_time")

# Flag previous non-200 status and time within 5 minutes
api_calls_with_prev = api_calls.withColumn(
    "prev_status", F.lag("status").over(window_spec)
).withColumn(
    "prev_call_time", F.lag("call_time").over(window_spec)
).filter(F.col("user_id").isNotNull())  # Filter out null user_ids

# Identify retries based on conditions
retries = api_calls_with_prev.filter(
    (F.col("prev_status").isNotNull()) &  # Has previous call
    (F.col("prev_status") != 200) &       # Previous call was non-200
    (F.col("call_time") <= F.col("prev_call_time") + F.expr("INTERVAL 5 MINUTES"))  # Within 5 minutes
).groupBy("user_id", "endpoint").count().withColumnRenamed("count", "retry_count")

# Sort the results as required
result = retries.orderBy(F.col("retry_count").desc(), "user_id", "endpoint")

# Select only the required columns (already done by groupBy, but explicitly select for clarity)
final_result = result.select("user_id", "endpoint", "retry_count")
