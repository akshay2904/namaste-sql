"""PySpark solution for: Highest and Lowest Cloud Costs
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

max_amount = cloud_costs.agg(F.max("amount")).collect()[0][0]
min_amount = cloud_costs.agg(F.min("amount")).collect()[0][0]

highest = cloud_costs.filter(F.col("amount") == max_amount) \
    .select("cost_id", "amount", "svc_name", F.lit("Highest Cost").alias("cost_type"))

lowest = cloud_costs.filter(F.col("amount") == min_amount) \
    .select("cost_id", "amount", "svc_name", F.lit("Lowest Cost").alias("cost_type"))

result = highest.unionAll(lowest)
