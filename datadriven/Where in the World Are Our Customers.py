"""PySpark solution for: Where in the World Are Our Customers?
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate total number of customers
total_customers = customers.count()

# Calculate share percentage for each country
country_shares = (
    customers
    .groupBy("country")
    .count()
    .withColumn("share_pct", F.round(F.col("count") * 100.0 / total_customers, 2))
    .orderBy(F.col("share_pct").desc(), F.col("country"))
    .select("country", "share_pct")
)
