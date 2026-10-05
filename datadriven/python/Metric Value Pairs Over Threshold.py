"""PySpark solution for: Metric Value Pairs Over Threshold
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Cross join the DataFrame with itself
result = employee_metrics.alias("e1").crossJoin(
    employee_metrics.alias("e2")
).filter(
    (F.col("e1.metric_value") < F.col("e2.metric_value")) & 
    (F.col("e1.metric_value") * F.col("e2.metric_value") > 11)
).select(
    F.col("e1.metric_value").alias("metric_value_1"),
    F.col("e2.metric_value").alias("metric_value_2")
).orderBy(
    F.col("e1.metric_value").asc(), 
    F.col("e2.metric_value").asc()
)

result.show()
