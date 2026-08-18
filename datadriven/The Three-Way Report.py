"""PySpark solution for: The Three-Way Report
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

session_agg = user_sessions.groupBy("user_id").agg(F.count("*").alias("session_count"))
txn_agg = transactions.groupBy("user_id").agg(F.sum("total_amount").alias("total_amount"))

result = users.join(session_agg, on="user_id", how="left") \
               .join(txn_agg, on="user_id", how="left") \
               .select("username", F.coalesce("session_count", F.lit(0)).alias("session_count"), 
                       F.coalesce("total_amount", F.lit(0)).alias("total_amount"))
