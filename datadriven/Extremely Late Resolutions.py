"""PySpark solution for: Extremely Late Resolutions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Define window partitioned by svc_name, ordered by fired_at ascending
window_spec = Window.partitionBy("svc_name").orderBy(F.col("fired_at").asc())

# Add row number and filter to keep only the earliest alert per service
ranked_df = alert_events.withColumn(
    "rnk", F.row_number().over(window_spec)
).filter(F.col("rnk") == 1)

# Select all columns (rnk included) and order by svc_name
result_df = ranked_df.orderBy("svc_name")

result_df.show()
