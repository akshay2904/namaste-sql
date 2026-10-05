"""PySpark solution for: Where the Lights Stay On
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

effective_hours = svc_health.groupBy("region").agg(
    F.sum(F.col("uptime") - F.coalesce(F.col("latency"), F.lit(0)) / 10.0).alias("total_effective_hours")
)

window = Window.orderBy(F.col("total_effective_hours").desc())

ranked = effective_hours.withColumn("rnk", F.dense_rank().over(window))

result = ranked.filter(F.col("rnk") <= 3).select(
    "region", 
    F.round(F.col("total_effective_hours"), 2).alias("total_effective_hours")
).orderBy(F.col("total_effective_hours").desc())

result.show()
