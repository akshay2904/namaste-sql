"""PySpark solution for: Healthiest Service Check History
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Find service(s) with highest-ever uptime score
max_uptime = svc_health.agg(F.max("uptime")).collect()[0][0]
healthiest_svcs = svc_health.filter(F.col("uptime") == max_uptime).select("svc_name").distinct()

# Prepare window for lag calculation
window_spec = Window.partitionBy("svc_name").orderBy("checked")

# Filter to healthiest services and compute lag + day difference
result = (svc_health
    .filter(F.col("svc_name").isin([row.svc_name for row in healthiest_svcs.collect()]))
    .withColumn("prev_checked", F.lag("checked").over(window_spec))
    .withColumn("days_diff", (F.unix_timestamp("checked") - F.unix_timestamp("prev_checked")) / 86400.0)
    .select("svc_name", "checked", "prev_checked", "days_diff")
    .orderBy(F.col("checked").desc())
)

result.show()
