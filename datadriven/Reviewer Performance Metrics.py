"""PySpark solution for: Reviewer Performance Metrics
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = code_reviews.filter(code_reviews.reviewer.isNotNull()) \
                     .groupBy('reviewer') \
                     .agg(F.countDistinct('repo_name').alias('reviewed_count'),
                          F.countDistinct(F.when(F.col('merged').isNotNull(), 'repo_name')).alias('merged_count'),
                          F.max('opened_at').alias('latest_review_date')) \
                     .filter(F.sum(F.when(F.col('merged').isNotNull(), 1).otherwise(0)) >= 1) \
                     .orderBy('reviewer')
