"""PySpark solution for: Third Highest Spender
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window = Window.orderBy(F.col("total_spend").desc())

# Calculate total spend per user and rank them
ranked = transactions.groupBy("user_id") \
    .agg(F.sum("total_amount").alias("total_spend")) \
    .withColumn("rnk", F.dense_rank().over(window))

# Filter the third highest total spend
third_highest_spend = ranked.filter(F.col("rnk") == 3)

# Join with customers table to get country information
result = third_highest_spend.join(customers, F.col("user_id") == F.col("customer_id")) \
    .select("user_id", "total_spend", "country")
