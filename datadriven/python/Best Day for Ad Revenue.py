"""PySpark solution for: Best Day for Ad Revenue
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Extract day of month from impression_time, handling the date format
# Sample dates use format 'YYYY-MM-DD HH:MM:SS', parse as timestamp
ad_impressions = ad_impressions.withColumn(
    'day_of_month',
    F.dayofmonth(F.to_timestamp('impression_time', 'yyyy-MM-dd HH:mm:ss'))
)

# Group by day of month and calculate aggregates
result = ad_impressions.groupBy('day_of_month').agg(
    F.avg('revenue').alias('avg_revenue'),
    F.max('revenue').alias('max_revenue'),
    # Click premium: average revenue for clicked impressions minus average for non-clicked
    (F.avg(F.when(F.col('clicked') == 1, F.col('revenue'))) - 
     F.avg(F.when(F.col('clicked') == 0, F.col('revenue')))).alias('click_premium')
).orderBy(
    # Sort by click_premium descending, with NULLs last
    F.col('click_premium').desc_nulls_last(),
    'day_of_month'
)

result.show()
