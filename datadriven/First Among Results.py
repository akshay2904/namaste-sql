"""PySpark solution for: First Among Results
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = search_queries.filter(search_queries.search_term.isNotNull()) \
    .withColumn('term_length', F.length('search_term')) \
    .groupBy('term_length') \
    .agg(
        F.count('*').alias('query_count'),
        F.sum(F.when(F.col('clicked_result') == 1, 1).otherwise(0)).alias('clicked_count')
    ) \
    .orderBy('term_length')
