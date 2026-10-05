"""PySpark solution for: The Days That Line Up
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Corrected filter for 'success' and date handling
data_pipes_filtered = data_pipes.filter(
    (F.col("start_at") > "2026-01-01") & 
    (F.lower(F.col("status")) == "success")
)

# Join on date (first 10 chars of datetime string, assuming format 'YYYY-MM-DD HH:MM:SS')
joined_df = data_pipes_filtered.join(
    batch_jobs, 
    F.expr("date(start_at) = date(started)")
)

# Group by pipe_name and priority, aggregate durations
result_df = joined_df.groupBy("pipe_name", "priority").agg(
    F.min("dur_secs").alias("min_duration"),
    F.avg("dur_secs").alias("avg_duration"),
    F.max("dur_secs").alias("max_duration")
).select("pipe_name", "priority", "min_duration", "avg_duration", "max_duration")

# Show results (optional, for development; remove in production)
result_df.show()
