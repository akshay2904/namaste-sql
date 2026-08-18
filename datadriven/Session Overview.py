"""PySpark solution for: Session Overview
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = users.join(user_sessions, users.user_id == user_sessions.user_id, 'left') \
             .groupBy(users.username) \
             .agg(F.count(user_sessions.session_id), F.max(user_sessions.session_duration_sec))
