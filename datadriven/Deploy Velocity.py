"""PySpark solution for: Deploy Velocity
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Parse deploy_at as timestamp if not already (assuming it's string for this example)
deploy_logs = deploy_logs.withColumn("deploy_at", F.to_timestamp("deploy_at"))

# Calculate gaps using LAG over partitions
window_spec = Window.partitionBy("svc_name").orderBy("deploy_at")
deploy_logs = deploy_logs.withColumn(
    "gap_days",
    F.datediff(F.col("deploy_at"), F.lag("deploy_at").over(window_spec))
)

# Filter out null gaps, compute average, and sort by service name
result = (
    deploy_logs
    .filter(F.col("gap_days").isNotNull())
    .groupBy("svc_name")
    .agg(F.avg("gap_days").alias("avg_gap_days"))
    .orderBy("svc_name")
)

result.show()
