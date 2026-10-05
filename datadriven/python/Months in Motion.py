"""PySpark solution for: Months in Motion
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Derive month from transaction_date and filter transactions
filtered_transactions = transactions.withColumn("month", F.month("transaction_date")).filter(F.col("total_amount") >= 5)

# Group by month and aggregate
result = filtered_transactions.groupBy("month").agg(
    F.countDistinct("user_id").alias("unique_users"),
    F.count("*").alias("total_transactions")
).orderBy("month")

# Show result (optional, for verification)
result.show()
