"""PySpark solution for: Spending Range
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate low and high for each user
user_range = users.join(transactions, "user_id") \
                 .groupBy("user_id", "username") \
                 .agg(F.min("total_amount").alias("low"), 
                      F.max("total_amount").alias("high"))

# Filter users with more than one transaction and calculate the gap
result = user_range.join(transactions.groupBy("user_id").count().alias("count"), "user_id") \
                   .filter(F.col("count") > 1) \
                   .select("username", "low", "high", (F.col("high") - F.col("low")).alias("high - low")) \
                   .orderBy((F.col("high") - F.col("low")).desc())
