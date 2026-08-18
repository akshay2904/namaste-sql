"""PySpark solution for: Where the Money Pools
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter transactions for the year 2026 and join with products
transactions_2026 = transactions.filter(F.year(F.col("transaction_date")) == 2026).join(products, "product_id")

# Calculate total revenue per category
category_revenues = transactions_2026.groupBy("category").agg(F.sum("total_amount").alias("category_revenue"))

# Calculate total spend for the year
total_spend = category_revenues.agg(F.sum("category_revenue").alias("total_spend")).first().total_spend

# Calculate revenue share for each category
result = category_revenues.withColumn("revenue_share", F.col("category_revenue") / total_spend).orderBy(F.col("category_revenue").desc())

# Select required columns
output = result.select("category", "category_revenue", "revenue_share")

print(output.show())
