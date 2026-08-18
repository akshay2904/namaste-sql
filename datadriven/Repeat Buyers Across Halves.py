"""PySpark solution for: Repeat Buyers Across Halves
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

resolved_transactions = transactions.withColumn("year", F.year("transaction_date")).withColumn("month", F.month("transaction_date"))

result = resolved_transactions.filter(F.col("year") == 2026).groupBy("user_id").agg(
    F.count(F.when(F.col("month") <= 6, 1)).alias("first_half"),
    F.count(F.when(F.col("month") > 6, 1)).alias("second_half")
).filter((F.col("first_half") >= 1) & (F.col("second_half") >= 1)).select("user_id").orderBy("user_id")

result.show()
