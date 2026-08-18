"""PySpark solution for: Users Who Churned in February
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter sessions in January 2026
january_sessions = user_sessions.filter((F.col('session_start') >= '2026-01-01') & (F.col('session_start') < '2026-02-01'))

# Filter sessions in February 2026
february_sessions = user_sessions.filter((F.col('session_start') >= '2026-02-01') & (F.col('session_start') < '2026-03-01'))

# Find users with sessions in January but not in February
users_with_sessions_in_january = january_sessions.select('user_id').distinct()
users_with_sessions_in_february = february_sessions.select('user_id').distinct()

result = users_with_sessions_in_january.join(users_with_sessions_in_february, on='user_id', how='left_anti')

result.show()
