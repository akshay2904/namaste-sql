"""PySpark solution for: The Heavy Hitters
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window = Window.partitionBy('provider').orderBy(F.col('total_spend').desc())

# Calculate the total spend and rank for each service
ranked_costs = cloud_costs.groupBy('provider', 'svc_name').agg(F.sum('amount').alias('total_spend')) \
    .withColumn('rnk', F.dense_rank().over(window))

# Filter the top 2 services for each provider
top_services = ranked_costs.filter(F.col('rnk') <= 2).orderBy('provider', 'total_spend', ascending=[True, False])

# Select the desired columns
result = top_services.select('provider', 'svc_name', 'total_spend')
