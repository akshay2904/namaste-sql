"""PySpark solution for: Keep Most Recent Record
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Define window specification: partition by user_id, order by signup_date descending
window_spec = Window.partitionBy("user_id").orderBy(F.col("signup_date").desc())

# Add row number to identify duplicates
ranked = users.withColumn("rn", F.row_number().over(window_spec))

# Keep only the most recent record for each user and select required columns
result = ranked.filter(F.col("rn") == 1).select("user_id", "username", "email", "signup_date")

result.show()
