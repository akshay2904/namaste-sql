"""PySpark solution for: Pipeline Overhead by Environment
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

per_state = data_pipes.filter(F.lower(F.col('status')).isin(['success', 'running'])) \
    .agg(F.avg(F.when(F.lower(F.col('status')) == 'success', F.abs(F.col('rows_in') - F.col('rows_out'))).otherwise(0)).alias('success_overhead'),
         F.avg(F.when(F.lower(F.col('status')) == 'running', F.abs(F.col('rows_in') - F.col('rows_out'))).otherwise(0)).alias('running_overhead'))

result = per_state.select(F.abs(F.col('success_overhead') - F.col('running_overhead')).alias('overhead_difference'))
