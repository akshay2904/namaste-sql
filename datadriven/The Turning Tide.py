"""PySpark solution for: The Turning Tide
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Extract month and year from bill_date
cloud_costs = cloud_costs.withColumn('month', F.month('bill_date')) \
                         .withColumn('year', F.year('bill_date'))

# Filter for year 2026
cloud_costs_2026 = cloud_costs.filter(F.col('year') == 2026)

# Calculate spend difference
spend_difference = cloud_costs_2026.groupBy('provider') \
                                    .agg((F.sum(F.when(F.col('month').between(7, 12), F.col('amount')).otherwise(0)) 
                                          - F.sum(F.when(F.col('month').between(1, 6), F.col('amount')).otherwise(0))) \
                                         .alias('spend_difference'))

# Order by spend difference in descending order
result = spend_difference.orderBy(F.col('spend_difference').desc())
