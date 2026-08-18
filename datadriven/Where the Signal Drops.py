"""PySpark solution for: Where the Signal Drops
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by endpoint, calculate total calls and error calls, filter endpoints with >= 20 calls, then compute error rate
result = (
    api_calls.groupBy("endpoint")
    .agg(
        F.count("*").alias("total_calls"),
        F.sum(F.when(F.col("status") >= 400, 1).otherwise(0)).alias("error_calls")
    )
    .filter(F.col("total_calls") >= 20)
    .withColumn(
        "error_rate",
        F.round((F.col("error_calls") * 100.0) / F.col("total_calls"), 2)
    )
    .orderBy(F.col("error_rate").desc(), F.col("endpoint").asc())
)
