"""PySpark solution for: Did We Actually Make Money?
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter out cancelled orders, group by region, aggregate profit, and order by total profit descending
result = (
    orders
    .filter(F.col("status") != "Cancelled")
    .groupBy("region")
    .agg(F.round(F.sum("profit"), 2).alias("total_profit"))
    .orderBy(F.col("total_profit").desc())
)

result.show()
