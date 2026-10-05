"""PySpark solution for: The Ides of March
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

api_calls = api_calls.filter(F.month("call_time") == 3) \
                    .groupBy("endpoint") \
                    .agg(F.max("latency").alias("max_latency")) \
                    .orderBy("max_latency", ascending=False)
