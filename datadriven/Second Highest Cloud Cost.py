"""PySpark solution for: Second Highest Cloud Cost
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get the distinct amounts in descending order, then skip the first row and take the next one
result = cloud_costs.select('amount').distinct().orderBy('amount', ascending=False).limit(1).offset(1)
