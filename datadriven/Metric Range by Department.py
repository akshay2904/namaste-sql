"""PySpark solution for: Metric Range by Department
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    employee_metrics
    .groupBy("department")
    .agg(
        F.round(F.avg("metric_value"), 2).alias("avg_value"),
        F.round(F.min("metric_value"), 2).alias("min_value"),
        F.round(F.max("metric_value"), 2).alias("max_value")
    )
    .orderBy(F.col("avg_value").desc())
)
