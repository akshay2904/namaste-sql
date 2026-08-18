"""PySpark solution for: API Calls With and Without Errors
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by endpoint and aggregate counts based on err_msg nullability
result = (
    api_calls
    .groupBy("endpoint")
    .agg(
        F.sum(F.when(F.col("err_msg").isNull(), 1).otherwise(0)).alias("no_error_count"),
        F.sum(F.when(F.col("err_msg").isNotNull(), 1).otherwise(0)).alias("error_count"),
        F.count("*").alias("total_count")
    )
    .orderBy("endpoint")
)
