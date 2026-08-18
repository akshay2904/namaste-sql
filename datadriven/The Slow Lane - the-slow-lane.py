"""PySpark solution for: The Slow Lane
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate server-wise average response time
server_latency = server_logs.groupBy("server_name").agg(
    F.avg(F.col("response_time_ms").cast("double")).alias("avg_response_ms")
)

# Calculate the overall average of server averages
overall_avg = server_latency.agg(F.avg("avg_response_ms").alias("overall_avg")).collect()[0].overall_avg

# Filter servers above overall average and sort
slow_servers = (
    server_latency.filter(F.col("avg_response_ms") > overall_avg)
    .orderBy(F.col("avg_response_ms").desc())
    .select("server_name", "avg_response_ms")
)

# Display results
slow_servers.show()
