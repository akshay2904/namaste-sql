"""PySpark solution for: Running Tab
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

window_spec = Window.partitionBy("user_id").orderBy("transaction_date")

result = transactions.select("user_id", "transaction_date", "total_amount") \
                      .withColumn("cumulative_spending", F.sum("total_amount").over(window_spec))

result.show()
