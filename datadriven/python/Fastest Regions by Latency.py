"""PySpark solution for: Fastest Regions by Latency
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Group by endpoint and calculate average latency
avg_latency_df = api_calls.groupBy("endpoint").agg(
    F.avg("latency").alias("avg_latency")
)

# Add dense rank ordered by average latency ascending
window_spec = Window.orderBy(F.col("avg_latency").asc())
ranked_df = avg_latency_df.withColumn(
    "rnk", F.dense_rank().over(window_spec)
)

# Filter top 3 ranks
result_df = ranked_df.filter(F.col("rnk") <= 3).select("endpoint", "avg_latency")

result_df.show()
