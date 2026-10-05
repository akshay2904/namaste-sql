"""PySpark solution for: Net Lines
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

repo_commits.groupBy('author') \
    .agg(F.sum('added') - F.sum('removed')) \
    .show()
