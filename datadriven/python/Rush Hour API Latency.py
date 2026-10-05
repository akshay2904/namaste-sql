"""PySpark solution for: Rush Hour API Latency
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import hour, avg

api_calls \
    .filter(hour("call_time").between(15, 17)) \
    .groupBy(hour("call_time").alias("hour")) \
    .agg(avg("latency").alias("avg_latency")) \
    .orderBy("hour") \
    .select("hour", "avg_latency")
