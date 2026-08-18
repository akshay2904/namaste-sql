"""PySpark solution for: Node Utilization
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate team totals per region, excluding teams with total_amount <= 0
team_totals = cost_allocs.groupBy("team_name", "region") \
    .agg(F.sum(F.col("amount").cast("double")).alias("total_amount")) \
    .filter(F.col("total_amount") > 0)

# Define window for ranking within each region
window = Window.partitionBy("region").orderBy(F.col("total_amount").desc())

# Rank teams by total_amount descending within each region
result = team_totals.withColumn("rnk", F.rank().over(window)) \
    .orderBy("region", "rnk", "team_name")

# Select required columns
result = result.select("team_name", "region", "total_amount", "rnk")
