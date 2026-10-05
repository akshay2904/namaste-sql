"""PySpark solution for: Top AWS Non-APAC Service Costs
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter AWS costs
aws_costs = cloud_costs.filter(F.lower(cloud_costs.provider) == 'aws')

# Find services in Asia-Pacific regions
ap_services = aws_costs.filter((aws_costs.region.like('%ap-%')) | (aws_costs.region.like('ap-%'))).select('svc_name').distinct()

# Filter services not in Asia-Pacific regions
filtered_costs = aws_costs.join(ap_services, 'svc_name', 'left_anti')

# Group by service and calculate max amount and average amount
result = filtered_costs.groupBy('svc_name') \
    .agg(F.max('amount').alias('max_amount'), F.avg('amount').alias('avg_amount')) \
    .filter(F.col('avg_amount') >= 90) \
    .select('svc_name', 'max_amount')
