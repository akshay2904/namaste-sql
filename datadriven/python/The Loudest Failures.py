"""PySpark solution for: The Loudest Failures
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

err_type_counts = err_tracks \
    .withColumn("year", F.year("first_at")) \
    .filter(F.col("year") == 2026) \
    .groupBy("err_type") \
    .agg(F.count("*").alias("err_count")) \
    .orderBy(F.col("err_count").desc()) \
    .select("err_type", "err_count")
