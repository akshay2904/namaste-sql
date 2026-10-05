"""PySpark solution for: Cloud Cost Stats by Provider
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Combine both sources into a single dataset
cloud_costs_subset = cloud_costs.select(
    F.col("provider"), 
    F.col("amount")
)

cost_allocs_subset = cost_allocs.select(
    F.col("category").alias("provider"), 
    F.col("amount")
)

combined = cloud_costs_subset.union(cost_allocs_subset)

# Aggregate statistics per provider
result = combined.groupBy("provider").agg(
    F.min("amount").alias("min_amount"),
    F.max("amount").alias("max_amount"),
    F.avg("amount").alias("avg_amount")
)

result.show()
