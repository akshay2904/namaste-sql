"""PySpark solution for: Most Popular Signup Day
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import types as T

# Map day of the week to its corresponding name
day_map = {0: 'Sunday', 1: 'Monday', 2: 'Tuesday', 3: 'Wednesday', 4: 'Thursday', 5: 'Friday', 6: 'Saturday'}

# Extract day of the week from signup_date
users_with_day = users.filter(F.col('signup_date').isNotNull()) \
    .withColumn('signup_day', F.udf(lambda x: day_map[x], T.StringType())(F.dayofweek('signup_date').cast(T.IntegerType())))

# Group by day of the week and count signups
signup_counts = users_with_day.groupBy('signup_day') \
    .count() \
    .withColumnRenamed('count', 'signup_count')

# Sort by signup count in descending order and then by day of the week in ascending order
sorted_signup_counts = signup_counts.orderBy('signup_count', ascending=False) \
    .withColumn('day_order', F.udf(lambda x: [v for k, v in day_map.items()].index(x), T.IntegerType())('signup_day')) \
    .orderBy('signup_count', ascending=False) \
    .orderBy('day_order', ascending=True) \
    .drop('day_order')
