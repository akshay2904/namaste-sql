"""PySpark solution for: The Ones Who Hold Attention
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join sessions to creators where the user is also a creator
joined = user_sessions.join(
    content_items,
    user_sessions.user_id == content_items.creator_id,
    "inner"
)

# Aggregate average session duration per creator and sort
result = joined.groupBy(content_items.creator_id) \
    .agg(F.avg(user_sessions.session_duration_sec).alias("avg_session_duration")) \
    .orderBy(content_items.creator_id)

result.show()
