"""PySpark solution for: Top Cost Categories
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import *
from pyspark.sql import Window

# Create a distinct mapping of (svc_name, region, period) to category
cat_map = cost_allocs.select("svc_name", "region", "period", "category").distinct()

# Join cloud_costs with the category map and aggregate
attributed_costs = cloud_costs.join(
    cat_map, 
    [
        cloud_costs.svc_name == cat_map.svc_name, 
        cloud_costs.region == cat_map.region, 
        date_format(cloud_costs.bill_date, "yyyy-MM") == cat_map.period 
    ], 
    "inner"
).groupBy(cat_map.category).agg(sum("amount").alias("total_amount")).orderBy(col("total_amount").desc()).limit(3)

attributed_costs.show()
