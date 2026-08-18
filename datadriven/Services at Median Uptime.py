"""PySpark solution for: Services at Median Uptime
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window to order by uptime and split into 2 tiles (ntiles=2)
window = Window.orderBy(F.col("uptime"))

# Calculate NTILE
ntiled_svc_health = svc_health.withColumn("half", F.ntile(2).over(window))

# Find the max uptime in the lower half (half=1)
max_uptime_in_lower_half = ntiled_svc_health.filter(F.col("half") == 1).agg(F.max("uptime")).first()[0]

# Filter for the lower half (half=1) with max uptime in that half
result = ntiled_svc_health.filter((F.col("half") == 1) & (F.col("uptime") == max_uptime_in_lower_half)).select("svc_name", "uptime")

result.show()
