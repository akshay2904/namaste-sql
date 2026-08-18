"""PySpark solution for: Bookends of the Week
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

weekly = transactions.groupBy(F.weekofyear('transaction_date').alias('week_num')) \
    .agg(
        F.sum('total_amount').alias('week_total'),
        F.sum(F.when(F.dayofweek('transaction_date') == 2, F.col('total_amount')).otherwise(0)).alias('monday_total'),
        F.sum(F.when(F.dayofweek('transaction_date') == 1, F.col('total_amount')).otherwise(0)).alias('sunday_total')
    )

result = weekly.select(
    F.format_string('%02d', 'week_num').alias('week_num'),
    F.round((F.col('monday_total') / F.col('week_total')) * 100).alias('monday_pct'),
    F.round((F.col('sunday_total') / F.col('week_total')) * 100).alias('sunday_pct')
).orderBy('week_num')
