"""PySpark solution for: Returning Buyers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate the date difference in days
transactions_with_date_diff = transactions.alias('t1').join(
    transactions.alias('t2'), 
    (F.col('t1.user_id') == F.col('t2.user_id')) & 
    (F.col('t2.transaction_date') > F.col('t1.transaction_date')) & 
    (F.datediff(F.col('t2.transaction_date'), F.col('t1.transaction_date')).between(1, 7))
)

# Select distinct user_id and sort the result
result = transactions_with_date_diff.select(F.col('t1.user_id')).distinct().orderBy(F.col('user_id'))

result.show()
