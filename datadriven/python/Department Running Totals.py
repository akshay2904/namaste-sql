"""PySpark solution for: Department Running Totals
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

window_spec = Window.partitionBy("department").orderBy("fiscal_year", "fiscal_quarter")

employee_metrics.withColumn(
    "running_total", F.sum("metric_value").over(window_spec)
).orderBy("department", "fiscal_year", "fiscal_quarter")
