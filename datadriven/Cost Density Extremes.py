"""PySpark solution for: Cost Density Extremes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Calculate cost density per region and provider
density = cloud_costs.groupBy("region", "provider").agg(
    F.round(F.sum("amount") / F.countDistinct("svc_name")).alias("cost_density")
)

# Filter for minimum and maximum density regions
min_density = density.agg(F.min("cost_density")).collect()[0][0]
max_density = density.agg(F.max("cost_density")).collect()[0][0]

result = density.filter(
    (F.col("cost_density") == min_density) | (F.col("cost_density") == max_density)
).select("region", "provider", "cost_density")

result.show()
