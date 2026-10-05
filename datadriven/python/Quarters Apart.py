"""PySpark solution for: Quarters Apart
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Extract quarter and year from call_time
api_calls = api_calls.withColumn('quarter', F.concat(F.format_string('%d-Q%d', F.year('call_time'), F.quarter('call_time'))))

# Calculate average latency for each quarter
avg_latency = api_calls.groupBy('quarter').agg(F.coalesce(F.avg('latency'), F.lit(120.0)).alias('avg_latency'))

# Sort quarters and calculate previous quarter's average latency
window = Window.orderBy('quarter')
prev_avg_latency = avg_latency.withColumn('prev_avg_latency', F.lag('avg_latency').over(window))

# Calculate quarter-over-quarter change
prev_avg_latency = prev_avg_latency.withColumn('qoq_change', F.col('avg_latency') - F.col('prev_avg_latency'))

# Filter for the three calendar years before 2026
result = prev_avg_latency.filter(F.year(F.split('quarter', '-').getItem(0)) < 2026)

# Select desired columns
result = result.select('quarter', 'avg_latency', 'prev_avg_latency', 'qoq_change')
