"""PySpark solution for: Regional Sales Growth QoQ
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter and aggregate Q3 and Q4 sales
q3 = transactions.filter(F.month('transaction_date').between(7, 9)) \
                 .groupBy('user_id') \
                 .agg(F.sum('total_amount').alias('q3_total')) \
                 .withColumnRenamed('user_id', 'region')

q4 = transactions.filter(F.month('transaction_date').between(10, 12)) \
                 .groupBy('user_id') \
                 .agg(F.sum('total_amount').alias('q4_total')) \
                 .withColumnRenamed('user_id', 'region')

# Join and calculate growth, ensuring column references are unambiguous
result = q4.join(q3, 'region') \
            .withColumn('growth_pct', ((F.col('q4_total') - F.col('q3_total')) / F.col('q3_total')) * 100.0) \
            .select('region', 'growth_pct')
