"""PySpark solution for: Shared Endpoints
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

filtered_endpoints = api_calls.groupBy("endpoint") \
                                .agg(F.countDistinct("user_id").alias("user_count")) \
                                .filter(F.col("user_count") > 1) \
                                .orderBy("user_count", ascending=False)  # Added ordering for clarity, not in original SQL

# Display or collect the result (assuming SparkSession 'spark' is already initialized)
filtered_endpoints.show()
