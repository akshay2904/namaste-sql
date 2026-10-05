"""PySpark solution for: Yesterday's Weather
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql.window import Window

# Filter positive non-null amounts, compute monthly totals
monthly = (
    cloud_costs
    .filter(F.col('amount').isNotNull() & (F.col('amount') > 0))
    .withColumn('ym', F.date_format(F.col('bill_date'), 'yyyy-MM'))
    .groupBy('ym')
    .agg(F.sum('amount').alias('total_amount'))
)

# Add previous month's total as forecast using a window
window_spec = Window.orderBy('ym')
ratios = monthly.withColumn(
    'prev_amount', 
    F.lag('total_amount').over(window_spec)
)

# Compute actual_cost, forecasted_cost, and percent error
result = (
    ratios
    .filter(F.col('prev_amount').isNotNull())
    .withColumn('actual_cost', F.col('total_amount'))
    .withColumn('forecasted_cost', F.col('prev_amount'))
    .withColumn(
        'pct_error',
        F.when(
            F.col('total_amount') > 0,
            F.abs((F.col('prev_amount') - F.col('total_amount')) / F.col('total_amount')) * 100
        )
    )
    .select('ym', 'actual_cost', 'forecasted_cost', 'pct_error')
    .orderBy('ym')
)
