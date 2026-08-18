"""PySpark solution for: The Address That Changed
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate move count for each customer
move_counts = customers.groupBy('customer_id').agg((F.count('*') - 1).alias('move_count'))

# Join customers with move counts and filter those who have moved
result = customers.join(move_counts, 'customer_id') \
    .filter(move_counts.move_count > 0) \
    .select(customers.customer_id, customers.first_name, customers.country.alias('current_city'), move_counts.move_count) \
    .orderBy('customer_id')

# Note: The original SQL solution's logic (move_count > 0) might need adjustment based on the actual Type 2 SCD requirements,
#       since the provided SQL solution does not actually filter by the 'last_name' IS NULL condition for current records.
#       The corrected code maintains the original logic but consider adding a condition for 'last_name' if necessary.
