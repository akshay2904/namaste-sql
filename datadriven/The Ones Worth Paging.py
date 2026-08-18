"""PySpark solution for: The Ones Worth Paging
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for the severity levels that require action, then group and count
result = (
    server_logs
    .filter(F.col("log_level").isin("CRITICAL", "ERROR", "WARN"))
    .groupBy("log_level")
    .agg(F.count("*").alias("total_count"))
    .orderBy("log_level")
)
