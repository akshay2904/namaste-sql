"""PySpark solution for: Where the Money Goes
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate total spend per provider and service
provider_service = cloud_costs.groupBy(F.lower('provider').alias('provider'), 'svc_name') \
    .agg(F.sum('amount').alias('total_spend'))

# Rank services within each provider by total spend
window = Window.partitionBy('provider').orderBy(F.col('total_spend').desc(), 'svc_name')
ranked = provider_service.withColumn('rn', F.row_number().over(window))

# Select top service per provider
top_services = ranked.filter(F.col('rn') == 1).select('provider', 'svc_name', 'total_spend') \
    .withColumnRenamed('svc_name', 'top_service')

# Order by total spend
result = top_services.orderBy(F.col('total_spend').desc())
