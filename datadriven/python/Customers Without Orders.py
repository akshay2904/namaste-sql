"""PySpark solution for: Customers Without Orders
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get distinct customer IDs that appear in transactions
ordering_customers = transactions.select("user_id").distinct()

# Count customers who are not in the ordering_customers list
no_order_count = customers.join(
    ordering_customers,
    customers.customer_id == ordering_customers.user_id,
    "left_anti"
).count()

# Return result as DataFrame with column no_order_count
result = spark.createDataFrame([(no_order_count,)], ["no_order_count"])
