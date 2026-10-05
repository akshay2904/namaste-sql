"""PySpark solution for: Average Fulfillment Lag
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter transactions with positive total_amount, compute days between transaction_date and today
result = (
    transactions
    .filter(F.col("total_amount") > 0)
    .select(
        "user_id",
        F.datediff(F.current_date(), F.to_date("transaction_date")).alias("days")
    )
    .groupBy("user_id")
    .agg(F.avg("days").alias("avg_days"))
    .orderBy(F.col("avg_days").desc())
)

result.show()
