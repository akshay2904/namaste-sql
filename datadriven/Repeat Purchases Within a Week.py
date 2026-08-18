"""PySpark solution for: Repeat Purchases Within a Week
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

transactions = transactions.withColumn('transaction_date', F.col('transaction_date').cast('timestamp'))
transactions = transactions.withColumn('row_num', F.row_number().over(Window.partitionBy('user_id').orderBy('transaction_date')))

result = transactions.alias('t1').join(
    transactions.alias('t2'), 
    (F.col('t1.user_id') == F.col('t2.user_id')) & (F.col('t1.row_num') < F.col('t2.row_num')) & 
    (F.datediff(F.col('t2.transaction_date'), F.col('t1.transaction_date')) <= 7)
).select(F.col('t1.user_id')).distinct()
