"""PySpark solution for: Daily Error Count Change
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Aggregate errors by date
daily_errors = err_tracks.select(
    F.to_date(F.col("first_at")).alias("error_date")
).groupBy("error_date").agg(F.count("*").alias("error_count"))

# Define window ordered by error_date for lag
window_spec = Window.orderBy("error_date")

# Add previous day's count and compute day-over-day change
result = daily_errors.withColumn(
    "prev_count", F.lag("error_count").over(window_spec)
).withColumn(
    "day_over_day_change", F.col("error_count") - F.col("prev_count")
).orderBy("error_date")

result.select("error_date", "error_count", "prev_count", "day_over_day_change")
