"""PySpark solution for: Tables With Most DQ Failures
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

dq_check_failures = (
    dq_checks.filter(F.col("passed") == 0)  # Filter rows where check failed
    .groupBy("tbl_name")                  # Group by table name
    .agg(F.count("*").alias("fail_count"))  # Count failures per group
    .orderBy(F.col("fail_count").desc())    # Sort by failure count descending
)
