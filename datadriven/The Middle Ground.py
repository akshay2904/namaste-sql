"""PySpark solution for: The Middle Ground
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate global min and max latency
min_latency = api_calls.agg(F.min("latency").alias("min_latency")).select("min_latency").first().min_latency
max_latency = api_calls.agg(F.max("latency").alias("max_latency")).select("max_latency").first().max_latency

# Filter and sum latency between min and max (exclusive)
result = api_calls.filter((F.col("latency") > min_latency) & (F.col("latency") < max_latency))\
                  .agg(F.min("latency").alias("min_latency"), 
                       F.max("latency").alias("max_latency"), 
                       F.sum("latency").alias("sum_between"))

# Note: Since we're filtering out the actual global min and max, 
#       the min_latency and max_latency in the result are the new boundaries of the filtered data
#       If you strictly need the original global min and max in the output, use the pre-calculated values
result = result.withColumn("min_latency", F.lit(min_latency)).withColumn("max_latency", F.lit(max_latency))

result.show()
