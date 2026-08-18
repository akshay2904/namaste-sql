"""PySpark solution for: Same-Day Session and Transaction Correlation
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Extract date from session_start and transaction_date
user_sessions = user_sessions.withColumn("session_date", F.date_trunc("day", F.to_timestamp("session_start")))
transactions = transactions.withColumn("transaction_date", F.to_date("transaction_date"))

# Join on user_id and date
joined_df = user_sessions.join(transactions, (transactions.user_id == user_sessions.user_id) & (F.col("transaction_date") == F.col("session_date")), "inner")

# Group by user_id and transaction_date, aggregate
result_df = joined_df.groupBy(transactions.user_id.alias("user_id"), "transaction_date").agg(
    F.countDistinct("transaction_id").alias("total_transactions"),
    F.sum("total_amount").alias("total_amount")
).orderBy("user_id", "transaction_date")

# Select and alias columns as per expected output
final_df = result_df.select(
    "user_id",
    F.col("transaction_date").alias("the_date"),
    "total_transactions",
    "total_amount"
)
