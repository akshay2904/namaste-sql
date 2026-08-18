"""PySpark solution for: Average Compensation by Department and Status
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Select team_name and amount from cost_allocs, group by team_name, 
# compute average amount, order alphabetically
result = (cost_allocs
    .groupBy("team_name")
    .agg(F.avg("amount").alias("avg_allocation"))
    .orderBy("team_name")
)

result.show()
