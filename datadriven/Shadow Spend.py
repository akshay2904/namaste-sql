"""PySpark solution for: Shadow Spend
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter and select from both DataFrames
cloud_filtered = cloud_costs.select("region", "svc_name", "amount").filter(
    (F.col("amount").isNotNull()) & (F.col("region").isNotNull())
)

alloc_filtered = cost_allocs.select("region", "svc_name", "amount").filter(
    (F.col("amount").isNotNull()) & (F.col("region").isNotNull())
)

# UNION (deduplicates identical rows)
combined = cloud_filtered.union(alloc_filtered).distinct()

# Group by region and service, sum amounts, sort descending
result = combined.groupBy("region", "svc_name").agg(
    F.sum("amount").alias("total_spend")
).orderBy(F.col("total_spend").desc())

result.show()
