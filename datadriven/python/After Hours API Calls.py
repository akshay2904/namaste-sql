"""PySpark solution for: After Hours API Calls
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for December 2026
dec_calls = api_calls.filter(F.col("call_time").between("2026-12-01", "2026-12-31"))

# Extract weekday (0=Sunday, 6=Saturday), hour, and month-day
out_of_hours = dec_calls.filter(
    (F.dayofweek(F.col("call_time")).isin(1, 7)) |  # Sunday(1) or Saturday(7)
    (F.hour(F.col("call_time")) < 9) |
    (F.hour(F.col("call_time")) >= 16) |
    (F.date_format(F.col("call_time"), "MM-dd").isin("12-25", "12-26"))
)

# Count and cast to decimal
result = out_of_hours.agg(
    F.count("*").cast("double").alias("after_hours_count")
)

result.show()
