"""PySpark solution for: Fastest Page View to Click
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Filter to relevant event types and add leading columns to find consecutive events
filtered = event_data.filter(F.col("event_type").isin("page_view", "button_click"))

window_spec = Window.orderBy("event_timestamp")

events_ordered = filtered.select(
    "user_id",
    "event_type",
    "event_timestamp",
    F.lead("event_type").over(window_spec).alias("next_type"),
    F.lead("event_timestamp").over(window_spec).alias("next_ts"),
    F.lead("user_id").over(window_spec).alias("next_user")
)

# Calculate gaps for page_view followed by button_click
gaps = events_ordered.filter(
    (F.col("event_type") == "page_view") & (F.col("next_type") == "button_click")
).select(
    F.col("user_id"),
    F.col("event_timestamp").alias("page_view_time"),
    F.col("next_ts").alias("click_time"),
    (F.unix_timestamp("next_ts") - F.unix_timestamp("event_timestamp")).alias("gap_seconds")
)

# Get the smallest time gap
result = gaps.orderBy("gap_seconds").limit(1)

result.select("user_id", "page_view_time", "click_time", "gap_seconds").show()
