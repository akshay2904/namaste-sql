"""PySpark solution for: Top Commit Authors by Repo
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

author_stats = repo_commits.groupBy('repo_name', 'author').agg(
    F.round(F.avg('added'), 1).alias('avg_added')
).withColumn(
    'rn', F.row_number().over(
        Window.partitionBy('repo_name').orderBy(F.col('avg_added').desc(), 'author')
    )
)

result = author_stats.filter('rn <= 3').groupBy('repo_name').agg(
    F.coalesce(
        F.max(F.when(F.col('rn') == 1, F.concat(F.col('author'), F.lit(' ('), F.col('avg_added').cast('string'), F.lit(')')))),
        F.lit('No first author')
    ).alias('best_author'),
    F.coalesce(
        F.max(F.when(F.col('rn') == 2, F.concat(F.col('author'), F.lit(' ('), F.col('avg_added').cast('string'), F.lit(')')))),
        F.lit('No second author')
    ).alias('second_best_author'),
    F.coalesce(
        F.max(F.when(F.col('rn') == 3, F.concat(F.col('author'), F.lit(' ('), F.col('avg_added').cast('string'), F.lit(')')))),
        F.lit('No third author')
    ).alias('third_best_author')
)
