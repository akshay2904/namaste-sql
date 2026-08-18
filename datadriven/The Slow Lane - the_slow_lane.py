"""PySpark solution for: The Slow Lane
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter api_calls for March and first call in 2026
march_api_calls = api_calls.filter((F.month(api_calls.call_time) == 3) & (F.year(api_calls.call_time) == 2026))

# Group by endpoint and find max latency
max_latency_api_calls = march_api_calls.groupBy('endpoint').agg(F.max('latency').alias('max_latency'))

# Sort by max_latency in descending order
sorted_max_latency_api_calls = max_latency_api_calls.orderBy('max_latency', ascending=False)

# Show results
sorted_max_latency_api_calls.show()
