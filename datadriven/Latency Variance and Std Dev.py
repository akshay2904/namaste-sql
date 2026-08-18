"""PySpark solution for: Latency Variance and Std Dev
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter successful API calls
successful_calls = api_calls.filter(F.col("status") == 200).select("latency")

# Compute aggregates
result = successful_calls.agg(
    F.avg("latency").alias("mean_latency"),
    (F.avg(F.col("latency") * F.col("latency")) - 
     F.avg("latency") * F.avg("latency")).alias("variance_latency")
)

# Add standard deviation as sqrt of variance
result = result.withColumn(
    "stddev_latency", 
    F.sqrt(F.col("variance_latency"))
).select("mean_latency", "variance_latency", "stddev_latency")

result.show()
