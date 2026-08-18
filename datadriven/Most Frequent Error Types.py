"""PySpark solution for: Most Frequent Error Types
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

err_counts = (
    err_tracks.groupBy("err_type")
    .agg(F.count("*").alias("err_count"))
    .orderBy(F.col("err_count").desc())
    .select("err_type", "err_count")
)

err_counts.show()
