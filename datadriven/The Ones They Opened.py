"""PySpark solution for: The Ones They Opened
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate open counts per campaign
open_counts = push_notifs.filter(F.col("opened") == 1).filter(F.col("campaign").isNotNull()) \
    .groupBy("campaign").agg(F.count("*").alias("open_count"))

# Calculate average open count across all campaigns
avg_open_count = open_counts.agg(F.avg("open_count").alias("avg_open")).first()["avg_open"]

# Filter campaigns above average and sort
result = open_counts.filter(F.col("open_count") > avg_open_count) \
    .orderBy(F.col("open_count").desc(), F.col("campaign"))

result.show()
