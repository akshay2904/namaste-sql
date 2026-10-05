"""PySpark solution for: Top 2 Callers per Endpoint
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Group by endpoint and user_id, count calls, then apply window for ranking
window_spec = Window.partitionBy("endpoint").orderBy(F.col("count").desc())
ranked_calls = api_calls.groupBy("endpoint", "user_id").count().withColumn("rnk", F.dense_rank().over(window_spec))

# Filter top 2 ranks and select required columns
result = ranked_calls.filter(F.col("rnk") <= 2).select("endpoint", "user_id", "rnk")

# Order by endpoint and rank for consistency
result = result.orderBy("endpoint", "rnk")

# Print or show the result (depending on your Spark setup/environment)
result.show()
