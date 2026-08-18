"""PySpark solution for: After the Handshake
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Add window row number per user ordered by call_time
window_spec = Window.partitionBy("user_id").orderBy("call_time")
ranked = api_calls.withColumn("rn", F.row_number().over(window_spec))

# Exclude first call per user, aggregate by endpoint
result = (
    ranked.filter(F.col("rn") > 1)
    .groupBy("endpoint")
    .agg(F.avg("latency").alias("avg_update_latency"))
    .orderBy(F.col("avg_update_latency").desc())
)

result = result.select("endpoint", "avg_update_latency")
