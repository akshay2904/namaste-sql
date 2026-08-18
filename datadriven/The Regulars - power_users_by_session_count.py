"""PySpark solution for: The Regulars
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

engaged_users = (
    user_sessions
    .groupBy("user_id")
    .agg(F.count("*").alias("session_count"))
    .filter(F.col("session_count") > 3)
)

# Display the result (if desired, not part of the transformation)
engaged_users.show()
