"""PySpark solution for: Early User Activation
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Convert dates and join with alias to avoid ambiguous column reference
users_with_date = users.withColumn("signup_date", F.to_date("signup_date"))
user_sessions_with_date = user_sessions.withColumn("session_start", F.to_timestamp("session_start").cast("date"))

# Join and use aliased column references to avoid ambiguity
result = (users_with_date.alias("u")
    .join(user_sessions_with_date.alias("s"), 
          F.col("u.user_id") == F.col("s.user_id"), "inner")
    .withColumn("days_diff", F.datediff(F.col("s.session_start"), F.col("u.signup_date")))
    .filter((F.col("days_diff") >= 0) & (F.col("days_diff") <= 365))
    .groupBy(F.col("u.user_id"), F.col("u.signup_date"))
    .agg(F.count("*").alias("session_count"))
    .filter(F.col("session_count") >= 1)
    .orderBy("user_id")
    .select("user_id", "signup_date", "session_count"))

result.show()
