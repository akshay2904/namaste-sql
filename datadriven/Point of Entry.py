"""PySpark solution for: Point of Entry
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window for row numbering by event timestamp per user
first_event_window = Window.partitionBy("user_id").orderBy("event_timestamp")

# Calculate first event for each user
first_events = event_data.withColumn("rn", F.row_number().over(first_event_window)).select("user_id", "event_type", "rn")

# Identify users whose first event was a page view
viewer_cohort = first_events.filter(F.col("rn") == 1).filter(F.col("event_type") == "page_view").select("user_id")

# Filter purchase events
purchases = event_data.filter(F.col("event_type") == "purchase").select("user_id", "event_id")

# Join viewer cohort with purchases and count purchases per user
result = viewer_cohort.join(purchases, "user_id", "leftouter").groupBy("user_id").agg(F.count("event_id").alias("purchase_count"))

# Fill null counts (no purchases) with 0 and order the result
result = result.select("user_id", F.coalesce("purchase_count", F.lit(0)).alias("purchase_count")).orderBy(F.col("purchase_count").desc(), F.col("user_id").asc())
