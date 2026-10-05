"""PySpark solution for: Lowest Latency per Service
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

result = (svc_health
    .filter(F.col("region") == "us-east-1")
    .groupBy("svc_name")
    .agg(F.min("latency").alias("min_latency"))
    .orderBy(F.col("min_latency").desc(), F.col("svc_name").asc())
)
