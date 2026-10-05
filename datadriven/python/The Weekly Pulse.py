"""PySpark solution for: The Weekly Pulse
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter users in at least one experiment
enrolled_users = experiments.select("user_id").distinct()

# Filter push_notifs for enrolled users and process
notification_breakdown = push_notifs.join(enrolled_users, "user_id", "inner") \
    .withColumn("day_of_week", F.dayofweek("sent_at")) \
    .withColumn("platform_lower", F.lower("platform")) \
    .groupBy("day_of_week") \
    .agg(
        F.sum(F.when(F.col("platform_lower") == "ios", 1).otherwise(0)).alias("ios_count"),
        F.sum(F.when(F.col("platform_lower") == "android", 1).otherwise(0)).alias("android_count"),
        F.sum(F.when(F.col("platform_lower") == "web", 1).otherwise(0)).alias("web_count")
    ) \
    .orderBy("day_of_week")

# Show the result
notification_breakdown.show()
