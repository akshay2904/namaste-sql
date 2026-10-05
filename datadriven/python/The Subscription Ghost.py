"""PySpark solution for: The Subscription Ghost
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window
window = Window.partitionBy('user_id', 'product_id').orderBy('transaction_date')

# Calculate lagged values
lagged = transactions.withColumn('prev_amount', F.lag('total_amount').over(window)) \
                     .withColumn('prev_date', F.lag('transaction_date').over(window))

# Filter for repeating charges
repeating_charges = lagged.filter((F.col('total_amount') == F.col('prev_amount')) & 
                                  ((F.col('transaction_date').cast('long') - F.col('prev_date').cast('long')) <= 35*86400)) \
                         .select('transaction_id', 'user_id', 'product_id', 'total_amount', 'transaction_date')

# Order by transaction date
result = repeating_charges.orderBy('transaction_date')
