"""PySpark solution for: Streak Status Changes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create a window to partition by svc_name and order by checked
window = Window.partitionBy("svc_name").orderBy("checked")

# Use the window to calculate the previous status
with_prev = svc_health.withColumn("previous_status", F.lag("status").over(window))

# Filter the rows where the status changed and select the required columns
result = with_prev.filter((F.col("previous_status").isNotNull()) & (F.col("previous_status") != F.col("status"))) \
    .select("svc_name", "checked", "previous_status", "status").withColumnRenamed("status", "current_status")
