"""PySpark solution for: Session Rank
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql.functions import row_number, desc

window = Window.partitionBy('user_id').orderBy(desc('session_duration_sec'))
result = user_sessions.filter('session_duration_sec is not null') \
    .select('user_id', 'session_duration_sec') \
    .withColumn('row_number', row_number().over(window)) \
    .select('user_id', 'session_duration_sec', 'row_number')
