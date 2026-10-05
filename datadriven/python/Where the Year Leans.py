"""PySpark solution for: Where the Year Leans
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define a function to calculate the half year ratio
def calculate_half_year_ratio(first_half_count, second_half_count):
    return F.when(second_half_count > 0, first_half_count / second_half_count).otherwise(0)

# Group by department and calculate the first half and second half counts
result = employee_metrics.groupBy('department') \
    .agg(
        F.sum(F.when(F.col('fiscal_quarter').isin(['Q1', 'Q2']), 1).otherwise(0)).alias('first_half_count'),
        F.sum(F.when(F.col('fiscal_quarter').isin(['Q3', 'Q4']), 1).otherwise(0)).alias('second_half_count')
    ) \
    .withColumn('half_year_ratio', calculate_half_year_ratio(F.col('first_half_count'), F.col('second_half_count'))) \
    .orderBy('department')

result.show()
