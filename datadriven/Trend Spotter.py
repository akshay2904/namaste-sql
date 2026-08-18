"""PySpark solution for: Trend Spotter
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

window_spec = Window.partitionBy('user_id').orderBy('transaction_date')

transactions = transactions.withColumn('prev_amount', F.lag('total_amount').over(window_spec))

result = transactions.select('user_id', 'total_amount', 'transaction_date', 'prev_amount')
