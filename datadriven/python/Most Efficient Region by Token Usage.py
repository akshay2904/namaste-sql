"""PySpark solution for: Most Efficient Region by Token Usage
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

api_tokens = (
    api_tokens
    .filter(api_tokens.expires.isNotNull())
    .groupBy('scope')
    .agg(
        F.avg(F.datediff('expires', 'issued')).alias('avg_lifetime_days'),
        F.avg('requests').alias('avg_requests')
    )
    .withColumn('requests_per_day_ratio', F.col('avg_requests') / F.col('avg_lifetime_days'))
    .orderBy(F.col('requests_per_day_ratio').desc())
)
