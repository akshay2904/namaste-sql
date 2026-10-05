"""PySpark solution for: 10 Lowest Uptime Services
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Group by service and compute the lowest recorded uptime
df_grouped = svc_health.groupBy("svc_name").agg(
    F.min("uptime").alias("min_uptime")
)

# Rank services by their lowest uptime using dense_rank to include ties at position 10
window_spec = Window.orderBy(F.col("min_uptime").asc())

result = (
    df_grouped.withColumn("rnk", F.dense_rank().over(window_spec))
    .filter(F.col("rnk") <= 10)
    .select("svc_name", "min_uptime")
    .orderBy(F.col("min_uptime").asc())
)
