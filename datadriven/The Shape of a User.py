"""PySpark solution for: The Shape of a User
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = event_data.groupBy("user_id") \
    .agg(
        F.sum(F.when(F.col("event_type") == "search", 1).otherwise(0)).alias("searches"),
        F.sum(F.when(F.col("event_type") == "add_to_cart", 1).otherwise(0)).alias("add_to_carts"),
        F.sum(F.when(F.col("event_type") == "purchase", 1).otherwise(0)).alias("purchases")
    ) \
    .orderBy("user_id")  # Added to align with expected output's ordering hint
result.show()
