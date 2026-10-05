"""PySpark solution for: Session Page View Distance
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification for ranking and counting views per session
window_spec = Window.partitionBy("session_id")

# Step 1: Rank page views and count views per session
page_ranked = page_views.join(user_sessions, "user_id", "inner").withColumn(
    "rn_asc", F.row_number().over(window_spec.orderBy("view_id"))
).withColumn(
    "rn_desc", F.row_number().over(window_spec.orderBy(F.col("view_id").desc()))
).withColumn(
    "view_count", F.count("*").over(window_spec)
).select(
    "user_id", "session_id", "dur_ms", "view_id", "rn_asc", "rn_desc", "view_count"
)

# Step 2: Calculate distance for each session
session_dist = page_ranked.filter(F.col("rn_asc") == 1).alias("f").join(
    page_ranked.filter(F.col("rn_desc") == 1).alias("l"),
    (F.col("f.session_id") == F.col("l.session_id")) & (F.col("f.view_count") > 1),
    "inner"
).withColumn(
    "distance", F.col("l.dur_ms") - F.col("f.dur_ms")
).select("distance")

# Step 3: Compute average distance
avg_distance = session_dist.agg(F.avg("distance").alias("avg_distance")).collect()[0]

print(avg_distance["avg_distance"])
