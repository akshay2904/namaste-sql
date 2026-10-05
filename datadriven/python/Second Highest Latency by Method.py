"""PySpark solution for: Second Highest Latency by Method
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window = Window.partitionBy("method").orderBy(F.col("latency").desc())

# Rank the rows by latency in each method group
ranked_api_calls = api_calls.select(
    "method",
    "endpoint",
    "latency",
    F.dense_rank().over(window).alias("rnk")
)

# Select the second-highest latency API endpoint in each method group
result = ranked_api_calls.filter(F.col("rnk") == 2).select("method", "endpoint", "latency")
