"""PySpark solution for: The Fast Lane
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    data_pipes
    .filter(F.col("dur_secs").between(0, 2700))
    .groupBy("pipe_name")
    .agg(F.avg("rows_out").alias("avg_rows_out"))
    .orderBy(F.col("avg_rows_out").desc())
)
