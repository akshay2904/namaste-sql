"""PySpark solution for: The Freshest Record
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Rank rows per (server_name, message) by most recent log_timestamp
window_spec = Window.partitionBy("server_name", "message").orderBy(F.desc("log_timestamp"))
ranked = server_logs.withColumn("rn", F.row_number().over(window_spec))

# Keep most recent occurrence and filter to last 7 days from 2026-12-28
result = (
    ranked.filter(F.col("rn") == 1)
    .filter(F.datediff(F.lit("2026-12-28"), F.col("log_timestamp")) <= 7)
    .select("log_id", "server_name", "log_level", "message", "response_time_ms", "log_timestamp")
    .orderBy(F.desc("log_timestamp"), F.col("log_id"))
)

result.show()
