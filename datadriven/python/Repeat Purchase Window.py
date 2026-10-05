"""PySpark solution for: Repeat Purchase Window
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

repeat_purchasers = transactions.withColumn(
    "prev_date", 
    F.lag("transaction_date").over(
        Window.partitionBy("user_id").orderBy("transaction_date")
    )
).withColumn(
    "date_diff", 
    F.datediff(F.col("transaction_date"), F.col("prev_date"))
).where(
    (F.col("date_diff") >= 1) & (F.col("date_diff") <= 7)  # Fix: added closing parenthesis
).select("user_id").distinct()
