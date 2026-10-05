"""PySpark solution for: The Shape of the Year
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Extract year-month from transaction_date and aggregate
result = (transactions
    .withColumn("month", F.date_format("transaction_date", "yyyy-MM"))
    .groupBy("month")
    .agg(
        F.sum("total_amount").alias("total_revenue"),
        F.count("*").alias("num_transactions")
    )
    .withColumn("avg_transaction_value", F.col("total_revenue") / F.col("num_transactions"))
    .orderBy("month")
    .select("month", "total_revenue", "num_transactions", "avg_transaction_value")
)
