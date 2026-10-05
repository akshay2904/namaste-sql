"""PySpark solution for: Mentorship User Pairs
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Self join to find all pairs with smaller user_id first
result = (users.alias("u1")
          .join(users.alias("u2"), 
                F.col("u1.user_id") < F.col("u2.user_id"))
          .filter(F.col("u1.age_bucket") != F.col("u2.age_bucket"))
          .filter(F.col("u1.account_status") == F.col("u2.account_status"))
          .filter(F.year("u1.signup_date") != F.year("u2.signup_date"))
          .select(F.col("u1.user_id").alias("user_id_1"),
                  F.col("u2.user_id").alias("user_id_2"))
)
