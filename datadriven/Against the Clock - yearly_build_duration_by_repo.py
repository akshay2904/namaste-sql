"""PySpark solution for: Against the Clock
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

ci_builds \
    .withColumn("build_year", F.year("built_at")) \
    .groupBy("repo_name", "build_year") \
    .agg(F.avg("dur_secs").alias("avg_duration")) \
    .orderBy(F.col("avg_duration").desc(), "repo_name", "build_year") \
    .select("repo_name", "build_year", "avg_duration")
