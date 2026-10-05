"""PySpark solution for: The Quiet Alarms
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = dq_checks.filter(
    (F.col("severity") == "low") & (F.year(F.col("run_at")) == 2026)
).agg(
    F.count("*").alias("low_severity_count")
)
