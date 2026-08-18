"""PySpark solution for: Once and Only Once
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

unique_vals = api_calls.groupBy('endpoint', 'latency').count().filter(F.col('count') == 1).select('endpoint', 'latency')

result = unique_vals.groupBy('endpoint').agg(F.max('latency').alias('rarest_highest')).orderBy('rarest_highest', ascending=False)

result.show()
