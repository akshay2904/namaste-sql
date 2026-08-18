"""PySpark solution for: Noisy Endpoints
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter calls with status >= 400
failed_calls = api_calls.filter(api_calls.status >= 400)

# Group by endpoint, count failures, and calculate average latency
failed_calls_agg = failed_calls.groupBy('endpoint') \
    .agg(F.count('*').alias('failure_count'), F.avg('latency').alias('avg_latency')) \
    .filter(F.col('failure_count') > 2)  # Having clause equivalent

# Sort by failure count in descending order
result = failed_calls_agg.orderBy(F.col('failure_count').desc())

# Show the result
result.show()
