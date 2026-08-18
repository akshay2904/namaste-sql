"""PySpark solution for: When It Rains
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define the conditions and assign a point for each condition met
condition1 = F.col("err_type").contains("Error").cast("integer")  # Check for 'Error' in err_type
condition2 = F.col("message").contains("null").cast("integer")  # Check for 'null' in message
condition3 = F.col("svc_name").contains("api").cast("integer")  # Check for 'api' in svc_name
condition4 = (F.upper(F.col("severity")) == "ERROR").cast("integer")  # Check for 'error' or 'ERROR' in severity

# Calculate the total points for each row
err_tracks_filtered = err_tracks.withColumn(
    "matchConditionCount", condition1 + condition2 + condition3 + condition4
).filter(
    F.col("matchConditionCount") > 1  # Filter rows where more than one condition is met
).drop("matchConditionCount")  # Remove the temporary calculation column

# Select the required columns (all in this case, as per the SQL solution)
result = err_tracks_filtered.select(
    "err_id", "err_type", "message", "svc_name", "severity", "count", "first_at"
)

# Show the result (assuming you want to display or further process it)
result.show()
