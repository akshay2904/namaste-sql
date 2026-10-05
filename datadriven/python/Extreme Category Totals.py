"""PySpark solution for: Extreme Category Totals
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter transactions to current year (using current date)
current_year = F.year(F.current_date())
yearly = (
    transactions
    .filter(F.year("transaction_date") == current_year)
    .join(products, "product_id")
    .groupBy("category")
    .agg(F.sum("total_amount").alias("total"))
)

# Find max and min totals
max_total = yearly.agg(F.max("total")).collect()[0][0]
min_total = yearly.agg(F.min("total")).collect()[0][0]

# Filter categories with max or min total
result = yearly.filter(
    (F.col("total") == max_total) | (F.col("total") == min_total)
).select("category", "total")

result.show()
