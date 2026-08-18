"""PySpark solution for: Feature Flag Adoption
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    feat_flags
    .groupBy("enabled")
    .agg(F.count("*").alias("flag_count"))
)
