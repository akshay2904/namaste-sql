"""PySpark solution for: Device Type Serving Most Users
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join user_sessions with devices on device_id and count distinct users per device type
type_users = (
    user_sessions
    .join(devices, user_sessions.device_id == devices.device_id, "inner")
    .groupBy(devices.device_type)
    .agg(F.countDistinct(user_sessions.user_id).alias("user_count"))
)

# Get the max user_count and filter to include all types with that count
max_count = type_users.agg(F.max("user_count")).collect()[0][0]

result = type_users.filter(F.col("user_count") == max_count)

result.select("device_type", "user_count").show()
