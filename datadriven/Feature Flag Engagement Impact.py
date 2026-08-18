"""PySpark solution for: Feature Flag Engagement Impact
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Convert date columns to proper date type for comparisons
feat_flags = feat_flags.withColumn("created_dt", F.to_date("created"))
user_sessions = user_sessions.withColumn("session_start_dt", F.to_date("session_start"))

# Add 30-day window end date
feat_flags = feat_flags.withColumn("created_plus_30", F.date_add("created_dt", 30))

# Join with condition: session_start within [created, created+30)
joined = feat_flags.join(
    user_sessions,
    (F.col("session_start_dt") >= F.col("created_dt")) & 
    (F.col("session_start_dt") < F.col("created_plus_30")),
    "left"
)

# Aggregate session counts per flag and build display name
result = (
    joined
    .groupBy("flag_id", "flag_name", "enabled")
    .agg(F.count("session_id").alias("launch_window_sessions"))
    .withColumn("display_name", F.regexp_replace("flag_name", "_", " "))
    .select("flag_name", "display_name", "enabled", "launch_window_sessions")
    .orderBy("flag_name")
)

result.show()
