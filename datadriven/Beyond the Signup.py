"""PySpark solution for: Beyond the Signup
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window
import datetime

# Filter to last 6 months from '2026-12-28'
six_months_ago = F.date_sub(F.to_date(F.lit('2026-12-28')), 180)  # approx 6 months in days
filtered_sessions = user_sessions.filter(
    F.col('session_start') >= six_months_ago
)

# Extract year-month and aggregate
result = (
    filtered_sessions
    .withColumn('month', F.date_format(F.col('session_start'), 'yyyy-MM'))
    .groupBy('month')
    .agg(
        F.countDistinct('user_id').alias('active_users'),
        F.avg('session_duration_sec').alias('avg_duration_sec')
    )
    .filter(F.count('*') > 3)  # only months with more than 3 sessions
    .orderBy('month')
)

result.show()
