"""PySpark solution for: Rapid Retry Detection
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

failed_calls = api_calls.filter((F.col('status') >= 400) & (F.col('user_id').isNotNull()))
retry_calls = api_calls.filter(F.col('status') < 400)

retry_storms = failed_calls.alias('a').join(
    retry_calls.alias('b'),
    on=['user_id', 'endpoint'],
    how='inner'
).filter(
    (F.col('b.call_time') > F.col('a.call_time')) &
    ((F.unix_timestamp('b.call_time') - F.unix_timestamp('a.call_time')) / 60 <= 5)
).select(
    F.col('a.user_id'),
    F.col('a.endpoint'),
    F.col('a.call_time').alias('failed_call_time'),
    F.col('b.call_time').alias('retry_call_time')
)
