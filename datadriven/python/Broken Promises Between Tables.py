"""PySpark solution for: Broken Promises Between Tables
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

fail_count = (
    dq_checks
    .filter(F.lower(F.col("rule")).contains("referential") & (F.col("passed") == 0))
    .agg(F.count("*").alias("fail_count"))
)
