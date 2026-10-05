"""PySpark solution for: Most Common Monday Outcome
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

experiments \
    .filter(F.dayofweek('created') == 2) \
    .groupBy('outcome') \
    .count() \
    .orderBy('count', ascending=False) \
    .select('outcome', F.col('count').alias('cnt')) \
    .show()
