"""PySpark solution for: Users With API Errors
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

users_with_errors = api_calls.filter(F.col("status") >= 400).agg(F.countDistinct("user_id").alias("users_with_errors"))
users_with_errors.show()
