"""PySpark solution for: Where the Money Pools
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import sum

# Filter by region, group by svc_name, calculate total cost and sort in descending order
result = cloud_costs.filter(cloud_costs.region == 'us-west-2') \
                    .groupBy('svc_name') \
                    .agg(sum('amount').alias('total_cost')) \
                    .orderBy('total_cost', ascending=False)

# Display the result
result.show()
