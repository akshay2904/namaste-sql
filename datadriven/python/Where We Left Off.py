"""PySpark solution for: Where We Left Off
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql.functions import col, row_number

# Define window partitioned by user_id, ordered by session_start and session_id descending
window_spec = Window.partitionBy("user_id").orderBy(col("session_start").desc(), col("session_id").desc())

# Add row number and filter for most recent session
result = (
    user_sessions
    .select("user_id", "pages_viewed", row_number().over(window_spec).alias("rn"))
    .filter(col("rn") == 1)
    .select("user_id", "pages_viewed")
    .orderBy("user_id")
)

result.show()
