"""PySpark solution for: Platform Speed
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import avg, max as _max, count

# Join user_sessions with devices on device_id
sessions_with_devices = user_sessions.join(devices, "device_id")

# Group by device_type and calculate average and max session duration and session count
device_sessions = sessions_with_devices.groupBy("device_type") \
    .agg(avg("session_duration_sec").alias("avg_duration"),
         _max("session_duration_sec").alias("max_duration"),
         count("*").alias("session_count"))

# Filter device types with at least 5 sessions
device_sessions = device_sessions.filter(count("*") >= 5)

# Order by average session duration in descending order
device_sessions = device_sessions.orderBy("avg_duration", ascending=False)

# Select required columns
device_sessions = device_sessions.select("device_type", "avg_duration", "max_duration", "session_count")
