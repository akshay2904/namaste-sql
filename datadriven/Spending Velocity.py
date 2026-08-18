"""PySpark solution for: Spending Velocity
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

result = transactions \
    .withColumn("row_num", F.row_number().over(Window.partitionBy("user_id").orderBy("transaction_date"))) \
    .withColumn("rolling_sum", F.sum("total_amount").over(Window.partitionBy("user_id").orderBy("transaction_date").rowsBetween(-6, 0))) \
    .select("user_id", "transaction_date", "total_amount", "rolling_sum") \
    .orderBy("user_id", "transaction_date")

result.show()
