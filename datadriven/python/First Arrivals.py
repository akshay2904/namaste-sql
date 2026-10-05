"""PySpark solution for: First Arrivals
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get the first purchase date for each user
first_purchase = transactions.groupBy('user_id').agg(F.min('transaction_date').alias('first_date'))

# Count the number of new customers for each date
new_customers = first_purchase.groupBy('first_date').count().alias('new_customers')

# Sort the result by date
result = new_customers.orderBy('first_date')

result.show()
