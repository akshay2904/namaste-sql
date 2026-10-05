"""PySpark solution for: Bargains and Budget-Busters
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Combine both cost tables
combined = cloud_costs.select("region", "svc_name", "amount") \
    .unionAll(cost_allocs.select("region", "svc_name", "amount"))

# Define window specs for ordering
window_desc = Window.partitionBy("region").orderBy(F.col("amount").desc(), F.col("svc_name").asc())
window_asc = Window.partitionBy("region").orderBy(F.col("amount").asc(), F.col("svc_name").asc())

# Add first_value columns for most expensive and cheapest
ranked = combined.withColumn("most_expensive", F.first("svc_name").over(window_desc)) \
    .withColumn("cheapest", F.first("svc_name").over(window_asc))

# Deduplicate to one row per region
result = ranked.select("region", "most_expensive", "cheapest").distinct()

result.show()
