"""PySpark solution for: The Extremes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter for 2025 and aggregate costs by svc_name
svc_year_costs = cloud_costs.filter(F.col("bill_date").between("2025-01-01", "2026-01-01")).groupBy("svc_name").agg(F.sum("amount").alias("total_amount"))

# Generate rank for high and low spending services
rank_window_high = Window.orderBy(F.col("total_amount").desc())
rank_window_low = Window.orderBy(F.col("total_amount").asc())
ranked = svc_year_costs.withColumn("rank_high", F.row_number().over(rank_window_high)).withColumn("rank_low", F.row_number().over(rank_window_low))

# Filter top 5 high and low spending services
top_bottom = ranked.filter((F.col("rank_high") <= 5) | (F.col("rank_low") <= 5)).orderBy(F.col("total_amount").asc())

# Select and limit output
result = top_bottom.select("svc_name", "total_amount")
result.show()
