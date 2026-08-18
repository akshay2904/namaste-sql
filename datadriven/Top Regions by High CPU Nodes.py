"""PySpark solution for: Top Regions by High CPU Nodes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate total CPU per region
total_cpu_per_region = infra_nodes.groupBy("region").agg(F.sum("cpu_pct").alias("total_cpu_pct"))

# Filter regions with high CPU nodes
high_cpu_nodes = infra_nodes.filter(infra_nodes.cpu_pct > 90)

# Calculate total CPU per region for high CPU nodes
total_cpu_per_region_high = high_cpu_nodes.groupBy("region").agg(F.sum("cpu_pct").alias("total_cpu_pct"))

# Rank regions by total CPU in descending order, allowing ties
window = Window.orderBy(F.col("total_cpu_pct").desc())
ranked_regions = total_cpu_per_region_high.withColumn("rank", F.dense_rank().over(window))

# Filter top 5 ranks, including ties, and select required columns
top_regions = ranked_regions.filter(F.col("rank") <= 5).select("region", "total_cpu_pct")

# Sort output for consistency with expected output
ordered_top_regions = top_regions.orderBy(F.col("total_cpu_pct").desc())
