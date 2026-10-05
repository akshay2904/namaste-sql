"""PySpark solution for: Longest Uptime Streak
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Add row number per service ordered by checked timestamp
window_spec = Window.partitionBy("svc_name").orderBy("checked")
ordered = svc_health.select(
    "svc_name", "status", "checked",
    F.row_number().over(window_spec).alias("rn")
)

# Keep only healthy checks (case-insensitive) and add another row number
healthy_only = ordered.filter(F.lower("status") == "healthy")
healthy_window = Window.partitionBy("svc_name").orderBy("rn")
healthy_only = healthy_only.withColumn("pass_rn", F.row_number().over(healthy_window))

# Group consecutive healthy statuses by subtracting row numbers
streaks = healthy_only.withColumn("grp", F.col("rn") - F.col("pass_rn"))
streaks = streaks.groupBy("svc_name", "grp").agg(F.count("*").alias("streak_len"))

# Get the longest streak, tie-break by service name
result = streaks.orderBy(F.desc("streak_len"), F.asc("svc_name")).limit(1)
result.select("svc_name", "streak_len").show()
