"""PySpark solution for: Monthly Running Total
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Filter out null product_id, extract month, and aggregate monthly totals
monthly = (
    transactions
    .filter(F.col("product_id").isNotNull())
    .withColumn("month", F.date_format(F.col("transaction_date"), "yyyy-MM"))
    .groupBy("product_id", "month")
    .agg(F.sum("total_amount").alias("monthly_total"))
)

# Add running cumulative total partitioned by product and ordered by month
window_spec = Window.partitionBy("product_id").orderBy("month")
result = (
    monthly
    .withColumn("cumulative_total", F.sum("monthly_total").over(window_spec))
    .select("product_id", "month", "monthly_total", "cumulative_total")
    .orderBy("product_id", "month")
)

result.show()
