"""PySpark solution for: Users Without Sessions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = users.join(user_sessions, users.user_id == user_sessions.user_id, "left") \
              .filter(user_sessions.session_id.isNull()) \
              .select(users.user_id, users.username, users.email)
