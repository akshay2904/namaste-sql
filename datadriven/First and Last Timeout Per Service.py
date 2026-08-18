"""PySpark solution for: First and Last Timeout Per Service
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for messages containing 'timed out'
filtered = err_tracks.filter(F.col('message').contains('timed out'))

# Group by service and aggregate min/max first_at
result = (filtered
    .groupBy('svc_name')
    .agg(
        F.min('first_at').alias('earliest_timeout'),
        F.max('first_at').alias('latest_timeout')
    )
    .orderBy('svc_name'))

result.show()
