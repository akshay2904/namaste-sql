"""PySpark solution for: Allocations in Top Spending Region
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Find region with highest total cloud spend
top_region_df = (cloud_costs
    .groupBy("region")
    .agg(F.sum("amount").alias("total_amount"))
    .orderBy(F.col("total_amount").desc(), F.col("region").asc())
    .select("region")
    .limit(1)
)

# Get regions from top_region_df as a list
top_region_list = [row.region for row in top_region_df.collect()]

# Filter cost_allocs for the top region and order by alloc_id
result = (cost_allocs
    .filter(F.col("region").isin(top_region_list))
    .orderBy("alloc_id")
)

result.show()
