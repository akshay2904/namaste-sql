"""PySpark solution for: Largest A/B Test by Participants
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by test_name, count distinct user_id, order descending, take top 1
result = (
    ab_results
    .groupBy("test_name")
    .agg(F.countDistinct("user_id").alias("unique_participants"))
    .orderBy(F.col("unique_participants").desc())
    .limit(1)
)

result.show()
