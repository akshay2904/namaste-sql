"""PySpark solution for: The Usual Suspects
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Create a filtered DataFrame for the year 2025
svc_health_2025 = svc_health.filter(F.year(F.col("checked")) == 2025)

# Count checks per region and service
regional_counts = svc_health_2025.groupBy("region", "svc_name").agg(F.count("*").alias("check_count"))

# Window to find max count per region
window_spec = Window.partitionBy("region").orderBy(F.col("check_count").desc())

# Assign rank based on check count within each region
ranked_counts = regional_counts.withColumn("rank", F.rank().over(window_spec))

# Filter for services with the max count (rank 1) in each region
leading_services = ranked_counts.filter(F.col("rank") == 1)

# Select and order the result
result = leading_services.select("region", "svc_name", "check_count").orderBy("region", F.col("check_count").desc(), "svc_name")

result.show()
