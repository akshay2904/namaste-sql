"""PySpark solution for: Under the Line
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate total spend per service per team
svc = cost_allocs.groupBy(F.lower('team_name').alias('team_name'), 'svc_name') \
    .agg(F.sum('amount').alias('svc_spend'))

# Calculate total spend and average spend per team
team = svc.groupBy('team_name') \
    .agg(F.sum('svc_spend').alias('total_spend'), F.avg('svc_spend').alias('avg_svc_spend'))

# Filter teams with total spend under twice the average team total
avg_team_total = team.agg(F.avg('total_spend')).first()[0]
filtered_team = team.filter(F.col('total_spend') < 2 * avg_team_total)

# Sort by total spend and team name
result = filtered_team.orderBy('total_spend', 'team_name')
