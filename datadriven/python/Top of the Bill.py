"""PySpark solution for: Top of the Bill
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter cloud costs for services present in cost allocations
filtered_cloud_costs = cloud_costs.join(cost_allocs.select("svc_name").distinct(), "svc_name", "inner")

# Calculate total amount per service and rank services by total amount
ranked_services = filtered_cloud_costs.groupBy("svc_name").agg(F.sum("amount").alias("total_amount")) \
    .withColumn("rank", F.rank().over(Window.orderBy(F.col("total_amount").desc())))

# Select top 2 services
top_services = ranked_services.filter(F.col("rank") <= 2).select("svc_name", "total_amount")
