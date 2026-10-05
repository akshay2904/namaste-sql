"""PySpark solution for: Top Percentile Spenders
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter transactions from the last 7 days and group by user_id to calculate total spend
recent_spend = transactions.filter(F.col("transaction_date") >= F.current_date() - F.expr("interval 7 days")) \
    .groupBy("user_id") \
    .agg(F.sum("total_amount").alias("total_spend"))

# Calculate percentile using NTILE and filter for top 1%
top_pctl_window = Window.orderBy(F.col("total_spend").desc())
top_spenders = recent_spend.withColumn("pctl", F.ntile(100).over(top_pctl_window)) \
    .filter(F.col("pctl") == 1) \
    .select("user_id", "total_spend")

top_spenders.show()
