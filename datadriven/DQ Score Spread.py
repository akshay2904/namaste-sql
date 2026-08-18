"""PySpark solution for: DQ Score Spread
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

dq_spread = (
    dq_checks
    .groupBy("tbl_name")
    .agg(F.sum("fail_pct").alias("total_fail"))
    .agg(
        (F.max("total_fail") - F.min("total_fail")).alias("dq_spread")
    )
)
