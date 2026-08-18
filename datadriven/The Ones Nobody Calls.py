"""PySpark solution for: The Ones Nobody Calls
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter for POST calls (case-insensitive) and count per endpoint
post_counts = api_calls.filter(F.upper("method") == "POST") \
    .groupBy("endpoint") \
    .agg(F.count("*").alias("call_count"))

# Add dense rank ordered by call count ascending
window_spec = Window.orderBy(F.col("call_count").asc())
ranked = post_counts.withColumn("rnk", F.dense_rank().over(window_spec))

# Filter to top 2 ranks and order results
result = ranked.filter(F.col("rnk") <= 2) \
    .orderBy(F.col("call_count").asc(), F.col("endpoint").asc()) \
    .select("endpoint", "call_count", "rnk")

result.show()
