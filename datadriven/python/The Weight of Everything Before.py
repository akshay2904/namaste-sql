"""PySpark solution for: The Weight of Everything Before
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql.functions import sum

window_spec = Window.partitionBy('user_id').orderBy('transaction_date')

result = transactions.select('user_id', 'transaction_date', 'total_amount') \
    .withColumn('running_total', sum('total_amount').over(window_spec)) \
    .select('user_id', 'transaction_date', 'running_total') \
    .orderBy('user_id', 'transaction_date')
