"""PySpark solution for: Where the Data Breaks
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

failed_checks = dq_checks.filter(F.col("passed") == 0)  # Filter failed checks

# Calculate failing counts and high severity fails per table
result = failed_checks.groupBy("tbl_name").agg(
    F.count("*").alias("failing_checks"),  # Total failed checks
    F.sum(F.when(F.lower(F.col("severity")).isin(['high', 'critical']), 1).otherwise(0)).alias("high_severity_failures")  # High severity failed checks
).orderBy(F.col("failing_checks").desc(), F.col("tbl_name"))  # Sort by failing checks descending, then table name
