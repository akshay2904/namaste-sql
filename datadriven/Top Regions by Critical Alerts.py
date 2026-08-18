"""PySpark solution for: Top Regions by Critical Alerts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter critical alerts and join with svc_health by svc_name
critical_alerts = (
    alert_events
    .filter(F.col("severity").ilike("critical"))  # Case-insensitive match
    .join(svc_health, "svc_name", "inner")
)

# Count critical alerts per region and rank by count in descending order
ranked_regions = (
    critical_alerts
    .groupBy("region")
    .agg(F.count("*").alias("critical_count"))
    .withColumn("rnk", F.rank().over(Window.orderBy(F.col("critical_count").desc())))
)

# Select top 5 regions by critical alert count
top_critical_regions = (
    ranked_regions
    .filter(F.col("rnk") <= 5)
    .select("region", "critical_count")
    .orderBy(F.col("critical_count").desc())
)

# Show the result (assuming you want to display or collect the results)
top_critical_regions.show()
