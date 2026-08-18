"""PySpark solution for: March Revenue by Customer
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for March transactions and aggregate by user
result = (transactions
    .filter(F.date_format("transaction_date", "MM") == "03")
    .groupBy("user_id")
    .agg(F.sum("total_amount").alias("march_total"))
    .orderBy(F.col("march_total").desc(), F.col("user_id"))
)

result.show()
