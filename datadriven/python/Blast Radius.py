"""PySpark solution for: Blast Radius
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

failure_statuses = ['failed', 'rolled_back']

result = (
    deploy_logs
    .withColumn('is_failure', F.lower(F.col('status')).isin(failure_statuses))
    .groupBy('svc_name')
    .agg(
        F.round(100.0 * F.sum(F.col('is_failure').cast('int')) / F.count('*'), 2).alias('failure_pct'),
        F.round(100.0 * F.sum(F.when(F.col('is_failure'), F.col('dur_secs')).otherwise(0)) / 
                F.sum(F.col('dur_secs')), 2).alias('failure_time_pct')
    )
    .orderBy('svc_name')
)
