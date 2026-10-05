"""PySpark solution for: Cumulative Sales Per Customer
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.window import Window
import pyspark.sql.functions as F

window_spec = Window.partitionBy("user_id").orderBy("transaction_date", "transaction_id")

result = transactions.withColumn(
    "cumulative_sales",
    F.sum("total_amount").over(window_spec)
).select(
    "user_id",
    "product_id",
    "total_amount",
    "transaction_date",
    "cumulative_sales"
).orderBy("user_id", "transaction_date", "transaction_id")

result.show()
