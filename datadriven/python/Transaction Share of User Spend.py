"""PySpark solution for: Transaction Share of User Spend
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Window to calculate total spend per user
user_window = Window.partitionBy("user_id")

result = (
    transactions.join(users, on="user_id", how="inner")
    .withColumn(
        "spend_share",
        F.col("total_amount") / F.sum("total_amount").over(user_window)
    )
    .select("transaction_id", "username", "total_amount", "spend_share")
    .orderBy("username", "transaction_id")
)
