"""PySpark solution for: CDN Traffic by Day and Hour
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Parse timestamp and extract weekday/hour
df = cdn_logs.withColumn("ts", F.to_timestamp("served_at"))
df = df.withColumn("weekday", F.date_format(F.col("ts"), "EEEE")) \
       .withColumn("hour", F.hour("ts"))
# Add numeric weekday for correct ordering (Sunday=0)
df = df.withColumn("weekday_num", F.dayofweek("ts") - 1)

# Group and aggregate
result = df.groupBy("weekday_num", "weekday", "hour").agg(
    F.round(F.avg(F.col("bytes") * 0.95), 2).alias("avg_net_bytes")
).orderBy("weekday_num", "hour")

result = result.select("weekday", "hour", "avg_net_bytes")
result.show()
