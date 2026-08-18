"""PySpark solution for: The Revenue Cliff
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Format transaction_date using Java datetime format 'yyyy-MM' instead of strftime format '%Y-%m'
monthly = transactions.groupBy(
    F.date_format('transaction_date', 'yyyy-MM').alias('month')
).agg(
    F.sum(F.col('total_amount').cast('double')).alias('revenue')
)

# Window to calculate previous month revenue
window_spec = Window.orderBy('month')
with_lag = monthly.withColumn('prev_revenue', F.lag('revenue').over(window_spec))

# Percentage change formula expression
pct_change_expr = (F.col('revenue') - F.col('prev_revenue')) / F.col('prev_revenue') * 100

result = with_lag.select(
    F.col('month'),
    F.round(F.col('revenue'), 2).alias('revenue'),
    F.round(F.col('prev_revenue'), 2).alias('prev_revenue'),
    F.round(pct_change_expr, 2).alias('pct_change'),
    F.when(pct_change_expr < -10, 'ALERT').otherwise('').alias('flag')
).orderBy('month')
