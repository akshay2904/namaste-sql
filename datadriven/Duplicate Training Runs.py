"""PySpark solution for: Duplicate Training Runs
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    ml_models
    .groupBy("mdl_name")
    .agg(F.count("*").alias("run_count"))
    .filter(F.col("run_count") > 1)
    .orderBy(F.col("run_count").desc())
)
