"""PySpark solution for: The Notification Lifecycle
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

push_notifs \
    .withColumn("status_lower", F.lower(F.col("status"))) \
    .withColumn("delivered", F.when(F.col("status_lower") == "delivered", 1).otherwise(0)) \
    .withColumn("opened_count", F.when(F.col("opened") == 1, 1).otherwise(0)) \
    .withColumn("failed", F.when(F.col("status_lower") == "failed", 1).otherwise(0)) \
    .groupBy("user_id") \
    .agg(
        F.sum("delivered").alias("delivered_count"),
        F.sum("opened_count").alias("opened_count"),
        F.sum("failed").alias("failed_count")
    ) \
    .join(users.select("user_id"), ["user_id"], "inner")
