"""PySpark solution for: Top Region by Order Volume
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (orders
          .filter(F.col('region').isNotNull())
          .groupBy('region')
          .agg(F.count('*').alias('order_count'))
          .orderBy(F.col('order_count').desc(), F.col('region').asc())
          .limit(1))
