"""PySpark solution for: Where the Money Went
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Ensure the bill_date is in date format (if not already)
cloud_costs = cloud_costs.withColumn("bill_date", F.to_date("bill_date"))

# Perform the join and calculation
result = (
    cost_allocs
    .join(
        cloud_costs, 
        [
            cost_allocs.svc_name == cloud_costs.svc_name, 
            F.year(cloud_costs.bill_date) == F.year(F.to_date(cost_allocs.period)), 
            F.month(cloud_costs.bill_date) == F.month(F.to_date(cost_allocs.period))
        ], 
        "inner"
    )
    .withColumn("prorated_amount", (cost_allocs.amount * cloud_costs.amount) / 8760.0) 
    # 8760 hours in a non-leap year
    .groupBy(cost_allocs.svc_name)  # specify which svc_name to use
    .agg(F.sum("prorated_amount").alias("prorated_cost"))
    .filter(F.col("prorated_cost") > 0) 
    # Only keep services with positive total
    .orderBy(F.col("prorated_cost").desc(), cost_allocs.svc_name.asc()) 
    .select(cost_allocs.svc_name, "prorated_cost")
)

# Optionally, if you want to display or show the result (not part of the transformation)
result.show()
