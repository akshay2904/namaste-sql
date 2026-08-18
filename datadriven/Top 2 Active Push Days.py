"""PySpark solution for: Top 2 Active Push Days
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

result = (
    push_notifs
    .filter(F.col('sent_at').between('2026-08-01', '2026-08-07'))
    .withColumn('send_date', F.to_date('sent_at'))  # Convert to date
    .withColumn('day_name', F.dayofweek('sent_at').cast('string'))  # Extract day and convert to string
    .groupBy('send_date', 'day_name')  # Group by both columns
    .agg(F.countDistinct('user_id').alias('unique_users'))
    .orderBy(F.col('unique_users').desc(), F.col('send_date').desc())  # Corrected orderBy with F.col
    .limit(2)
    .select('day_name', 'send_date', 'unique_users')
)
