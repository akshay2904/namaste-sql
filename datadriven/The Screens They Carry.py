"""PySpark solution for: The Screens They Carry
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter users in the 25-34 age bucket, join with sessions and devices, 
# count distinct device_ids per device_type, and order by count descending
result = (
    users
    .filter(F.col("age_bucket") == "25-34")
    .join(user_sessions, "user_id")
    .join(devices, "device_id")
    .groupBy("device_type")
    .agg(F.countDistinct("device_id").alias("device_count"))
    .orderBy(F.desc("device_count"))
)

result.show()
