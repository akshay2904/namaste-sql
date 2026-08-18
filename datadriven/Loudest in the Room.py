"""PySpark solution for: Loudest in the Room
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Extract the date part from call_time and count calls per day/endpoint
daily_counts = (
    api_calls
    .withColumn("call_day", F.to_date("call_time"))
    .groupBy("call_day", "endpoint")
    .agg(F.count("*").alias("call_count"))
)

# Rank endpoints per day by call count descending (dense rank for ties)
window_spec = Window.partitionBy("call_day").orderBy(F.desc("call_count"))
ranked = daily_counts.withColumn("rnk", F.dense_rank().over(window_spec))

# Filter top 3 per day and order as requested
result = (
    ranked
    .filter(F.col("rnk") <= 3)
    .select("call_day", "endpoint", "rnk")
    .orderBy(F.col("call_day").asc(), F.col("rnk").asc(), F.col("endpoint").asc())
)

result.show()
