"""PySpark solution for: Department Snapshot
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter out null metric values, group by department, and compute aggregates
result = (
    employee_metrics
    .filter(F.col("metric_value").isNotNull())
    .groupBy("department")
    .agg(
        F.min("metric_value").alias("min_metric"),
        F.max("metric_value").alias("max_metric"),
        F.avg("metric_value").alias("avg_metric"),
        (F.max("metric_value") - F.min("metric_value")).alias("spread"),
        F.count("*").alias("cnt")
    )
    .filter(F.col("cnt") > 5)  # HAVING COUNT(*) > 5
    .drop("cnt")
    .orderBy(F.col("spread").desc())
)

result.show()
