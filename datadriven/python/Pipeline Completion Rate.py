"""PySpark solution for: Pipeline Completion Rate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

data_pipes = data_pipes.filter(data_pipes.rows_in > 0) \
                       .groupBy(data_pipes.pipe_name) \
                       .agg(F.avg((data_pipes.rows_out * 100.0) / data_pipes.rows_in).alias("avg_completion_pct")) \
                       .select("pipe_name", "avg_completion_pct")
