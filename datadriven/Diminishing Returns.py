"""PySpark solution for: Diminishing Returns
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Create result bucket based on results_count
df = search_queries.withColumn(
    'result_bucket',
    F.when(F.col('results_count') == 0, 'none')
     .when(F.col('results_count') <= 3, 'small')
     .otherwise('larger')
)

# Aggregate: calculate click-through rate as percentage
result = df.groupBy('result_bucket').agg(
    F.round(
        100.0 * F.sum(F.when(F.col('clicked_result').isNotNull(), 1).otherwise(0)) / F.count('*'),
        2
    ).alias('click_through_pct')
)

# Order by click-through rate descending
result = result.orderBy(F.col('click_through_pct').desc())

result.show()
