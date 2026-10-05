"""PySpark solution for: Spend and Rank
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

ranked = users.join(transactions, users.user_id == transactions.user_id) \
               .groupBy(users.username) \
               .agg(F.sum(transactions.total_amount).alias('total')) \
               .withColumn('rnk', F.rank().over(Window.orderBy(F.col('total').desc())))

result = ranked.filter(F.col('rnk') <= 5).select('username', 'total', 'rnk')
