"""PySpark solution for: The Slow Build
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter transactions for 2026 and extract month
monthly_df = (
    transactions
    .filter(F.year("transaction_date") == 2026)
    .withColumn("month", F.date_format("transaction_date", "yyyy-MM"))
    .groupBy("month")
    .agg(F.sum("total_amount").alias("monthly_revenue"))
)

# Define window for running average
window_spec = Window.orderBy("month").rowsBetween(Window.unboundedPreceding, Window.currentRow)

# Calculate cumulative average and round
result = (
    monthly_df
    .withColumn("cumulative_avg", F.round(F.avg("monthly_revenue").over(window_spec), 0))
    .select("month", "monthly_revenue", "cumulative_avg")
    .orderBy("month")
)

result.show()
