"""PySpark solution for: DQ Fail Rate by Table
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter rows with non-null severity, group by table, compute average fail percentage, and order ascending
result = (
    dq_checks
    .filter(F.col("severity").isNotNull())
    .groupBy("tbl_name")
    .agg(F.avg("fail_pct").alias("avg_fail_pct"))
    .orderBy("avg_fail_pct")
)

result.show()
