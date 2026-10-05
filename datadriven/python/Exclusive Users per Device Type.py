"""PySpark solution for: Exclusive Users per Device Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join user_sessions with devices and find users using exactly one device type
joined = user_sessions.join(devices, "device_id")

# Group by user, collect distinct device types per user
user_device_types = (
    joined.groupBy("user_id")
    .agg(F.collect_set("device_type").alias("device_types"))
)

# Filter users with only one distinct device type
exclusive_users = user_device_types.filter(F.size("device_types") == 1)

# Explode to get the single device_type per user
exclusive = exclusive_users.select(
    "user_id",
    F.explode("device_types").alias("device_type")
)

# Count exclusive users per device type
result = (
    exclusive.groupBy("device_type")
    .agg(F.count("*").alias("exclusive_user_count"))
    .orderBy(F.col("exclusive_user_count").desc(), F.col("device_type").asc())
)

result.show()
