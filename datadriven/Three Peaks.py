"""PySpark solution for: Three Peaks
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate monthly cost
monthly = cost_allocs.groupBy('team_name', 'period').agg(F.sum('amount').alias('monthly_cost'))

# Get distinct monthly costs
distinct_costs = monthly.select('team_name', 'monthly_cost').distinct()

# Rank monthly costs
window = Window.partitionBy('team_name').orderBy(F.col('monthly_cost').desc())
ranked = distinct_costs.withColumn('rnk', F.dense_rank().over(window))

# Filter top 3 costs and order
result = ranked.filter(F.col('rnk') <= 3).select('team_name', 'monthly_cost').orderBy('team_name', F.col('monthly_cost').desc())
