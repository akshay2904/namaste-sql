"""PySpark solution for: Highest Throughput Pipelines
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    data_pipes
    .filter(F.year(F.col("start_at")) == 2026)
    .groupBy("pipe_name")
    .agg(F.max("rows_out").alias("max_throughput"))
    .orderBy(F.col("max_throughput").desc())
)
