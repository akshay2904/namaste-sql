"""PySpark solution for: Top Metric per Department
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification: partition by department, order by metric_value in descending order
window_spec = Window.partitionBy("department").orderBy(F.col("metric_value").desc())

# Apply the window function to rank metric_values within each department
ranked_metrics = employee_metrics.withColumn("rnk", F.rank().over(window_spec))

# Filter for rank 1 and select the desired columns
result = ranked_metrics.filter(F.col("rnk") == 1).select("department", "metric_name", "metric_value", "rnk")

# Optionally, order the result by department and metric_name (as in the SQL solution)
result = result.orderBy("department", "metric_name")

# Show the result (uncomment to display)
# result.show()
