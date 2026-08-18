"""PySpark solution for: Tokens With Non-Read Scope Prefix
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

api_tokens \
  .groupBy('owner_id') \
  .agg(F.sum(F.when(F.col('scope').startswith('read'), 0).otherwise(1)).alias('scope_violations')) \
  .filter(F.col('scope_violations') > 0) \
  .count()
