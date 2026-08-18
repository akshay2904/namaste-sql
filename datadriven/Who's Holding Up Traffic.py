"""PySpark solution for: Who's Holding Up Traffic
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter to June 2026 calls
june_calls = api_calls.filter(F.date_format("call_time", "yyyy-MM") == "2026-06")

# Calculate daily unique users per endpoint
daily_users = (june_calls
    .groupBy("endpoint", F.date_format("call_time", "yyyy-MM-dd").alias("call_day"))
    .agg(F.countDistinct("user_id").alias("daily_users"))
)

# Handle endpoints with no calls in June (expected output includes them with 0)
all_endpoints = api_calls.select("endpoint").distinct()
june_endpoints = daily_users.select("endpoint").distinct()
missing_endpoints = all_endpoints.subtract(june_endpoints).withColumn("call_day", F.lit(None)).withColumn("daily_users", F.lit(0))

# Combine June data with missing endpoints
combined = daily_users.unionByName(missing_endpoints)

# Calculate average daily active users and sort
result = (combined
    .groupBy("endpoint")
    .agg(F.avg("daily_users").alias("avg_daily_active_users"))
    .orderBy("endpoint")
)

result.show()
