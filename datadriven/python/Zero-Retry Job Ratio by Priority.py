"""PySpark solution for: Zero-Retry Job Ratio by Priority
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate zero-retry count per row
zero_retry = F.when(batch_jobs.retries == 0, 1).otherwise(0)

# Group by priority and aggregate
result = (
    batch_jobs
    .groupBy("priority")
    .agg(
        F.sum(zero_retry).alias("zero_retry_count"),
        F.count("*").alias("total_jobs")
    )
    .withColumn("ratio", F.col("zero_retry_count") / F.col("total_jobs"))
    .orderBy(F.col("ratio").asc())
)

# Show the result
result.show()
