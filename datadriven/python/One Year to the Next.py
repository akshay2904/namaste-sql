"""PySpark solution for: One Year to the Next
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate yearly signups
yearly_signups = users.groupBy(F.year('signup_date').alias('signup_year')) \
    .agg(F.countDistinct('user_id').alias('signups'))

# Calculate year-over-year growth percentage
window = Window.orderBy('signup_year')
yoy_growth = yearly_signups.withColumn('prev_year_signups', F.lag('signups').over(window)) \
    .withColumn('yoy_growth_pct', F.round((F.col('signups') - F.col('prev_year_signups')) / F.col('prev_year_signups') * 100))

# Select desired columns and order by signup year
result = yoy_growth.select('signup_year', 'signups', 'prev_year_signups', 'yoy_growth_pct') \
    .orderBy('signup_year')
