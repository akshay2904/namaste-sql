"""PySpark solution for: Smooth Latency
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.partitionBy("endpoint").orderBy("call_time", "call_id").rowsBetween(Window.unboundedPreceding, Window.currentRow)

# Apply the window function to calculate running average
result_df = api_calls.filter(api_calls.latency.isNotNull()) \
                      .select("endpoint", "latency", 
                              F.avg("latency").over(window_spec).alias("running_avg"))
