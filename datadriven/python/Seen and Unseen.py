"""PySpark solution for: Seen and Unseen
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (push_notifs
          .groupBy('platform')
          .agg((F.sum('opened') * 100.0 / F.count('*')).alias('open_rate_pct'))
          .orderBy('open_rate_pct', 'platform', ascending=False))
