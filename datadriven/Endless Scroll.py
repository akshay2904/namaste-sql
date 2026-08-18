"""PySpark solution for: Endless Scroll
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import sum as _sum

user_sessions.groupBy('user_id') \
             .agg(_sum('pages_viewed').alias('total_pages')) \
             .orderBy('total_pages', ascending=False) \
             .limit(5)
