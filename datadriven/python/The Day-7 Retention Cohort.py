"""PySpark solution for: The Day-7 Retention Cohort
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate cohort week
users = users.withColumn('cohort_week', F.concat(F.year('signup_date'), F.lit('-W'), F.weekofyear('signup_date')))

# Join users with page_views
joined_df = users.join(page_views, 'user_id', 'left')

# Calculate days since signup
joined_df = joined_df.withColumn('days_since_signup', F.datediff('viewed_at', 'signup_date'))

# Filter users with at least 7 days since signup
filtered_df = joined_df.filter(F.datediff(F.current_date(), 'signup_date') >= 7)

# Calculate retained users
retained_users = filtered_df.withColumn('retained_user', F.when(F.col('days_since_signup') >= 7, F.col('user_id')))

# Group by cohort week and calculate metrics
result_df = retained_users.groupBy('cohort_week') \
    .agg(
        F.countDistinct('user_id').alias('total_signups'),
        F.countDistinct(F.col('retained_user')).alias('retained_users')
    ) \
    .withColumn('retention_pct', F.round(F.col('retained_users') / F.col('total_signups') * 100, 1))

# Order by cohort week
result_df = result_df.orderBy('cohort_week')
