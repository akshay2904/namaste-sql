"""PySpark solution for: Successful Call Volume per Endpoint
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create a window to order rows within each duplicate group
window = Window.partitionBy('user_id', 'endpoint', 'call_time').orderBy('call_id')

# Select the row with the lowest call_id from each duplicate group
deduped = api_calls.withColumn('row_num', F.row_number().over(window)).filter('row_num = 1').drop('row_num')

# Count successful calls per endpoint
successful_calls = deduped.filter('status = 200').groupBy('endpoint').count().withColumnRenamed('count', 'successful_calls')

# Order the results from most to fewest successful calls
result = successful_calls.orderBy('successful_calls', ascending=False)
