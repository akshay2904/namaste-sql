"""PySpark solution for: The Relentless Searchers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.orderBy(F.col("query_count").desc(), F.col("user_id").asc())

# Calculate query count per user and assign rank
ranked_users = (
    search_queries
    .groupBy("user_id")
    .agg(F.count("*").alias("query_count"))
    .withColumn("rnk", F.row_number().over(window_spec))
)

# Select the required columns
result = ranked_users.select("user_id", "query_count", "rnk")
