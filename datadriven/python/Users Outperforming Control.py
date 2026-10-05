"""PySpark solution for: Users Outperforming Control
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate average control values for each test
avg_control_values = ab_results.filter(F.lower(ab_results.variant) == 'control') \
                                .groupBy('test_name') \
                                .agg(F.avg('value').alias('avg_control_value'))

# Join treatment_a results with average control values and filter outperformed users
outperformed_users = ab_results.filter(ab_results.variant == 'treatment_a') \
                               .join(avg_control_values, 'test_name') \
                               .filter(ab_results.value > avg_control_values.avg_control_value)

# Group by user ID and average control value, and select the maximum treatment value
result = outperformed_users.groupBy('user_id', 'avg_control_value') \
                            .agg(F.max('value').alias('treatment_value')) \
                            .select('user_id', 'treatment_value', 'avg_control_value') \
                            .orderBy('user_id')
