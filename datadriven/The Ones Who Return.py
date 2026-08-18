"""PySpark solution for: The Ones Who Return
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

repeat_member_pct = (
    transactions
    .groupBy("user_id")
    .agg(F.count("*").alias("txn_count"))
    .withColumn("is_repeat", F.when(F.col("txn_count") >= 2, 1).otherwise(0))
    .agg(((F.sum("is_repeat") / F.count("*")) * 100).alias("repeat_member_pct"))  # alias added to the result of agg
    .withColumn("repeat_member_pct", F.round(F.col("repeat_member_pct"), 2))
    .select("repeat_member_pct")
)

print(repeat_member_pct.show())
