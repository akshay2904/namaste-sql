"""PySpark solution for: Transaction Timeline
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (users
          .join(transactions, users.user_id == transactions.user_id)
          .groupBy(users.user_id, users.username)
          .agg(
              F.min(transactions.transaction_date).alias('first_purchase'),
              F.max(transactions.transaction_date).alias('latest_purchase'),
              F.round(F.sum(transactions.total_amount), 2).alias('lifetime_spend')
          )
          .select('username', 'first_purchase', 'latest_purchase', 'lifetime_spend')
          .orderBy('username')
         )
