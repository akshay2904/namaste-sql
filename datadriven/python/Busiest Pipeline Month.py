"""PySpark solution for: Busiest Pipeline Month
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

result = (
    data_pipes
    .filter(F.col("start_at").isNotNull())
    .withColumn("month", F.date_format("start_at", "MM"))
    .groupBy("month")
    .agg(F.count("*").alias("pipeline_runs"))
    .orderBy(F.col("pipeline_runs").desc())
    .limit(1)
)
