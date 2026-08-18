"""PySpark solution for: Top API Caller
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Group by user_id and count the number of calls per user
call_counts = api_calls.groupBy("user_id").agg(F.count("*").alias("call_count"))

# Sort the counts in descending order and select the top row
most_active_user = call_counts.select("user_id", "call_count").orderBy(F.col("call_count").desc()).limit(1)

most_active_user.show()  # Display the result
