"""PySpark solution for: Rolling Revenue Average
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate monthly revenue, excluding refunds
monthly_rev = transactions.filter(F.col('total_amount') >= 0) \
    .groupBy(F.date_format('transaction_date', 'yyyy-MM').alias('ym')) \
    .agg(F.sum('total_amount').alias('revenue'))

# Calculate 3-month rolling average
window_spec = Window.orderBy('ym').rowsBetween(-2, 0)
rolling_avg = monthly_rev.withColumn('rolling_avg', F.avg('revenue').over(window_spec))

# Sort by year-month and select desired columns
result = rolling_avg.select('ym', 'rolling_avg').orderBy('ym')
