"""PySpark solution for: Top Users by Recent Spend
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

recent_transactions = transactions.filter(
    (F.col("transaction_date") >= F.current_date() - F.expr("interval 30 days"))
    & (F.col("transaction_date") <= F.current_date())
)

total_spend = recent_transactions.groupBy("user_id").agg(
    F.sum("total_amount").alias("total_spend")
).filter(F.col("total_spend") > 0)

top_users = total_spend.orderBy(F.col("total_spend").desc(), F.col("user_id").asc()).limit(10)

top_users.show()
