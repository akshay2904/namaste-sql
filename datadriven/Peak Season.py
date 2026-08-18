"""PySpark solution for: Peak Season
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate modulo 100 for order_id and transaction_id
orders_mod = orders.withColumn("order_mod", F.col("order_id") % 100)
transactions_mod = transactions.withColumn("transaction_mod", F.col("transaction_id") % 100)

# Join orders and transactions on the modulo column (fixed using F.col in on clause)
joined = orders_mod.join(transactions_mod, F.col("order_mod") == F.col("transaction_mod"))

# Filter for transactions in the year 2026
joined_2026 = joined.filter(F.year(F.col("transaction_date")) == 2026)

# Extract month from transaction_date, group by region and month, and aggregate profit
grouped = joined_2026.groupBy("region", F.month("transaction_date").alias("txn_month")).agg(F.sum("profit").alias("total_profit"))

# Rank regions by total_profit in descending order
ranked = grouped.withColumn("rank", F.dense_rank().over(Window.orderBy(F.col("total_profit").desc())))

# Select the top-ranked region-month pairing and format month as string (using format_number correctly)
result = ranked.filter(F.col("rank") == 1).select(
    F.col("region"), 
    F.format_number(F.col("txn_month"), 2).alias("txn_month"),  # Format to 2 decimal places (effectively 2 digits for month)
    F.col("total_profit")
)

result.show()
