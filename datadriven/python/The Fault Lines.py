"""PySpark solution for: The Fault Lines
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

negative_rates = (
    users
    .join(event_data, on='user_id')
    .groupBy('account_status')
    .agg(
        (F.sum(F.when(F.col('event_type').isin(['error', 'timeout', 'crash']), 1).otherwise(0)).cast('double') / 
         F.count('*').cast('double')).alias('negative_rate')
    )
    .orderBy('negative_rate', ascending=False)
)

negative_rates.show()
