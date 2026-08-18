"""PySpark solution for: Selling Where Nobody Lives
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get all unique countries from customers (excluding NULL)
customer_countries = customers.select("country").where(F.col("country").isNotNull()).select(F.col("country").alias("region"))

# Use except to find regions in orders not present in customer_countries
unknown_shipping_destinations = orders.select("region").exceptAll(customer_countries)

# Select distinct regions and sort
result = unknown_shipping_destinations.select("region").distinct().orderBy("region")

result.show()
