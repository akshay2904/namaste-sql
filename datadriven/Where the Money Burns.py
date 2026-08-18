"""PySpark solution for: Where the Money Burns
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Compute the overall average amount across all records
overall_avg = cloud_costs.agg(F.avg("amount")).collect()[0][0]

# Group by svc_name, compute average amount, filter > overall average, sort
result = (
    cloud_costs.groupBy("svc_name")
    .agg(F.avg("amount").alias("avg_amount"))
    .filter(F.col("avg_amount") > overall_avg)
    .select("svc_name")
    .orderBy("svc_name")
)
