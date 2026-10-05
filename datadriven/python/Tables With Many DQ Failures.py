"""PySpark solution for: Tables With Many DQ Failures
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

failed_checks = dq_checks.filter(dq_checks.passed == 0) \
    .groupBy(dq_checks.tbl_name) \
    .count() \
    .filter(F.col('count') >= 3)

ranked_checks = failed_checks.withColumn('rank', F.dense_rank().over(Window.orderBy(F.col('count').desc())))

result = ranked_checks.select(F.col('tbl_name'), F.col('count').alias('fail_count')) \
    .orderBy(F.col('count').desc())

result.show()
