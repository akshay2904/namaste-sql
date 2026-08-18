"""PySpark solution for: First Contact
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Define window to rank calls per user per endpoint by time
window_spec = Window.partitionBy("user_id", "endpoint").orderBy("call_time")

# Get first call for each user-endpoint pair, then aggregate
result = (
    api_calls
    .withColumn("rn", F.row_number().over(window_spec))
    .filter(F.col("rn") == 1)
    .groupBy("endpoint")
    .agg(F.avg("latency").alias("avg_initial_call_latency"))
    .orderBy(F.col("avg_initial_call_latency").desc())
)
