"""PySpark solution for: The Weight of the Cloud
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter cloud_costs for 2026
cc_2026 = cloud_costs.filter(F.year(F.col("bill_date")) == 2026)

# Join on service name
