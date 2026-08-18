"""PySpark solution for: All at Once
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Event days: All distinct days from issued dates
event_days = api_tokens.select(F.col('issued').cast('date').alias('d')).distinct()

# Active tokens count per day
day_active = event_days.join(
    api_tokens, 
    (F.col('issued').cast('date') <= F.col('d')) & 
    ((F.col('expires').isNull()) | (F.col('expires').cast('date') > F.col('d'))), 
    'inner'
) \
.withColumn('date_d', F.col('d')) \
.groupBy('date_d') \
.agg(F.count('*').alias('active_count'))

# Join each token with all days it was active
token_days = api_tokens.join(
    day_active, 
    (F.col('issued').cast('date') <= F.col('date_d')) & 
    ((F.col('expires').isNull()) | (F.col('date_d') < F.col('expires').cast('date'))), 
    'inner'
) \
.select('token_id', 'date_d', 'active_count') \
.withColumnRenamed('date_d', 'd')

# Calculate peak concurrent count per token
ranked = token_days.withColumn(
    'peak_concurrent', 
    F.max('active_count').over(Window.partitionBy('token_id'))
)

# Filter for peak days and get the earliest peak date
result = ranked.filter(F.col('active_count') == F.col('peak_concurrent')) \
    .groupBy('token_id', 'peak_concurrent') \
    .agg(F.min('d').alias('peak_date')) \
    .select('token_id', 'peak_concurrent', 'peak_date') \
    .orderBy('token_id')
