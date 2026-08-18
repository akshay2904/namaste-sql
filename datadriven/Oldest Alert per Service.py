"""PySpark solution for: Oldest Alert per Service
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define window partitioning by svc_name and ordering by fired_at asc
window = Window.partitionBy("svc_name").orderBy(F.col("fired_at").asc())

# Apply window function to get row numbers, filter unresolved alerts (resolved IS NULL)
oldest_unresolved = (
    alert_events
    .withColumn("rn", F.row_number().over(window))
    .filter((F.col("resolved").isNull()))  # Filter alerts that are unresolved
    .filter(F.col("rn") == 1)  # Select only the first row per partition (oldest)
    .select("svc_name", "alert_id", "severity", "status", "fired_at")
    .orderBy("svc_name")
)

# Show results (assuming this is for verification; remove or replace with desired action)
oldest_unresolved.show()
