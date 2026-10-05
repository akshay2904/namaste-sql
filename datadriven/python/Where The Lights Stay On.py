"""PySpark solution for: Where The Lights Stay On
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

svc_health.groupBy('region') \
          .agg(F.avg('uptime').alias('avg_uptime')) \
          .orderBy(F.col('avg_uptime').desc())
