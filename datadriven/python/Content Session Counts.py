"""PySpark solution for: Content Session Counts
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join page_views with user_sessions on user_id and count distinct session_ids per page_url
result = (
    page_views
    .join(user_sessions, page_views.user_id == user_sessions.user_id)
    .groupBy(page_views.page_url)
    .agg(F.countDistinct(user_sessions.session_id).alias("unique_sessions"))
    .orderBy(F.desc("unique_sessions"))
)

result.show()
