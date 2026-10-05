"""PySpark solution for: Single Service Owners
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

svc_health \
  .groupBy('svc_name') \
  .agg(F.countDistinct('svc_name').cast('double').alias('service_count')) \
  .filter(F.col('service_count') == 1) \
  .orderBy('svc_name') \
  .limit(10) \
  .show()
