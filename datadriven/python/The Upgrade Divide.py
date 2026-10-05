"""PySpark solution for: The Upgrade Divide
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join users with sessions, then left join devices
joined = user_sessions.join(users, user_sessions.user_id == users.user_id, "inner") \
    .join(devices, user_sessions.device_id == devices.device_id, "left")

# Disambiguate user_id by selecting specific columns
joined = joined.select(
    users.age_bucket.alias("age_bucket"),
    users.user_id.alias("user_id"),
    devices.os_name.alias("os_name"),
    devices.os_version.alias("os_version")
)

# Filter out null age buckets
joined = joined.filter(F.col("age_bucket").isNotNull())

# Aggregate by age bucket
result = joined.groupBy("age_bucket").agg(
    F.countDistinct(
        F.when(
            (F.col("os_name") == "iOS") & 
            (F.col("os_version").like("16%") | 
             F.col("os_version").like("17%") | 
             F.col("os_version").like("18%")),
            F.col("user_id")
        )
    ).alias("ios_users"),
    F.countDistinct("user_id").alias("total_users")
)

# Order by total_users descending, then age_bucket descending
result = result.orderBy(F.col("total_users").desc(), F.col("age_bucket").desc())

result.show()
