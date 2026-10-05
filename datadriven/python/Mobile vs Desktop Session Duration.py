"""PySpark solution for: Mobile vs Desktop Session Duration
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join sessions with devices on device_id
joined_df = user_sessions.join(devices, user_sessions.device_id == devices.device_id, "inner")

# Filter for year 2025
joined_df = joined_df.filter(F.year("session_start") == 2025)

# Group by user_id, compute max mobile and desktop session durations
result = joined_df.groupBy("user_id").agg(
    F.max(F.when(F.col("device_type") == "mobile", F.col("session_duration_sec"))).alias("longest_mobile"),
    F.max(F.when(F.col("device_type") == "desktop", F.col("session_duration_sec"))).alias("longest_desktop")
)

result.show()
