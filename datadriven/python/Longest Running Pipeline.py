"""PySpark solution for: Longest Running Pipeline
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Select pipe_name, order by dur_secs descending, take the first row
result = data_pipes.select("pipe_name").orderBy(F.col("dur_secs").desc()).limit(1)
