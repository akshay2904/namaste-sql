"""PySpark solution for: Top Endpoint by Power Users
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate the ratio of standard method calls for each user and endpoint
user_method_ratio = api_calls.groupBy('user_id', 'endpoint') \
    .agg((F.sum(F.when(F.col('method').isin(['GET', 'POST', 'PUT', 'DELETE']), 1).otherwise(0)) / F.count('*')).alias('method_ratio')) \
    .filter(F.col('method_ratio') >= 0.5)

# Count the number of power users for each endpoint
power_user_count = user_method_ratio.groupBy('endpoint') \
    .agg(F.countDistinct('user_id').alias('power_user_count'))

# Get the endpoint with the most power users
result = power_user_count.orderBy('power_user_count', ascending=False).limit(1)

result.show()
