"""PySpark solution for: Top 2 Rate-Limited Clients
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter rows where blocked > 0 and handle None values by replacing with 0
blocked_requests = rate_limits.withColumn('blocked', F.coalesce(F.col('blocked'), F.lit(0))) \
                              .filter(F.col('blocked') > 0)

# Group by client and sum blocked requests
blocked_counts = blocked_requests.groupBy('client') \
                                  .agg(F.sum('blocked').alias('total_blocked'))

# Sort by total_blocked descending and client ascending, then limit to top 2
topBlockedClients = blocked_counts.orderBy(F.col('total_blocked').desc(), F.col('client').asc()) \
                                   .limit(2)

# Select only the desired columns
result = topBlockedClients.select('client', 'total_blocked')

result.show()
