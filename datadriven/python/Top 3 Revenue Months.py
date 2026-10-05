"""PySpark solution for: Top 3 Revenue Months
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Extract year and month from transaction_date and group by it
year_month_sales = transactions.withColumn("year_month", F.date_format("transaction_date", "yyyy-MM")) \
                               .groupBy("year_month") \
                               .agg(F.sum("total_amount").alias("total_sales"))

# Order by total sales in descending order and get the top 3
top_3_year_month_sales = year_month_sales.orderBy("total_sales", ascending=False).limit(3)
