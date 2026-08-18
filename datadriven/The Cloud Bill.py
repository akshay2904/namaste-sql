"""PySpark solution for: The Cloud Bill
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Convert provider to upper case for consistent comparison
cloud_costs = cloud_costs.withColumn('provider', F.upper(F.col('provider')))

# Extract month from bill_date
cloud_costs = cloud_costs.withColumn('month', F.date_trunc('month', F.col('bill_date')))

# Group by month and sum amounts by provider
result = cloud_costs.groupBy('month') \
    .agg(
        F.sum(F.when(F.col('provider') == 'AWS', F.col('amount')).otherwise(0)).alias('aws_total'),
        F.sum(F.when(F.col('provider') == 'GCP', F.col('amount')).otherwise(0)).alias('gcp_total'),
        F.sum(F.when(F.col('provider') == 'AZURE', F.col('amount')).otherwise(0)).alias('azure_total')
    ) \
    .orderBy('month')

# Format month to 'YYYY-MM' string
result = result.withColumn('month', F.date_format(F.col('month'), 'yyyy-MM'))

# Select desired columns
result = result.select('month', 'aws_total', 'gcp_total', 'azure_total')
