"""PySpark solution for: Top Services by Uptime
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

svc_avg = svc_health.groupBy("svc_name").agg(
    F.round(F.avg("uptime"), 2).alias("avg_uptime")
).filter(F.count("*") >= 5)

window = Window.orderBy(F.col("avg_uptime").desc())
ranked = svc_avg.withColumn("rank", F.dense_rank().over(window))

result = ranked.filter(F.col("rank") <= 3).orderBy("rank", "svc_name")
