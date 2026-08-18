"""PySpark solution for: Active User Penetration Rate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Find the latest session start time across the entire dataset
global_max_df = user_sessions.agg(F.max("session_start").alias("global_max_start"))

# Join user sessions with devices to
