"""PySpark solution for: iOS Sessions by Device Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join sessions with devices, filter for mobile, group by device_type, and count sessions
result = (
    user_sessions
    .join(devices, user_sessions.device_id == devices.device_id, "inner")
    .filter(F.col("device_type") == "mobile")
    .groupBy("device_type")
    .agg(F.count("session_id").alias("session_count"))
)

result.show()
