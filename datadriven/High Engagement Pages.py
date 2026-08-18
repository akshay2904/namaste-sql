"""PySpark solution for: High Engagement Pages
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join page_views with user_sessions on user_id
# Group by session_id and sum dur_ms, filtering results > 5 seconds
result = page_views.join(
    user_sessions, 
    page_views.user_id == user_sessions.user_id
).groupBy(
    user_sessions.session_id
).agg(
    F.sum(page_views.dur_ms).alias("result")
).filter(
    F.col("result") > 5000  # 5 seconds = 5000 ms
).orderBy(
    F.col("result").desc()
).select("session_id", "result")
