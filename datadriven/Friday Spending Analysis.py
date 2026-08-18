"""PySpark solution for: Friday Spending Analysis
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

transactions_with_week = transactions.withColumn(
    "week_number", F.weekofyear(F.col("transaction_date"))
).withColumn(
    "day_of_week", F.dayofweek(F.col("transaction_date"))
).withColumn(
    "month", F.month(F.col("transaction_date"))
)

# Filter for Fridays (dayofweek=6 in Spark: Sunday=1, ..., Saturday=7)
fridays = transactions_with_week.filter(
    (F.col("day_of_week") == 6) &
    (F.col("week_number") <= 13) &
    (F.col("month").isin(1, 2, 3))
)

result = fridays.groupBy("week_number").agg(
    F.avg("total_amount").alias("avg_amount")
).orderBy("week_number")

result.select("week_number", "avg_amount").show()
