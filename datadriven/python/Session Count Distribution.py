"""PySpark solution for: Session Count Distribution
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

qualifying_users = users.filter((F.col('signup_date') >= '2024-01-01') & (F.col('signup_date') <= '2026-12-31')).select('user_id')

feb_sessions = user_sessions.join(qualifying_users, 'user_id') \
    .filter(F.expr('year(session_start) = 2026 AND month(session_start) = 2')) \
    .groupBy('user_id') \
    .count() \
    .withColumnRenamed('count', 'session_count')

result = feb_sessions.groupBy('session_count') \
    .count() \
    .withColumnRenamed('count', 'user_count') \
    .orderBy('session_count')

result.show()
