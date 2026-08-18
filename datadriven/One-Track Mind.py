"""PySpark solution for: One-Track Mind
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Find users who have made non-GET calls
non_get_users = (
    api_calls.filter((F.upper(F.col("method")) != 'GET') & F.col("user_id").isNotNull())
    .select("user_id")
    .distinct()
)

# Filter to GET-only users and count per endpoint
counts_df = (
    api_calls.filter(
        (F.upper(F.col("method")) == 'GET') &
        F.col("user_id").isNotNull() &
        ~F.col("user_id").isin(non_get_users.select("user_id").rdd.flatMap(lambda x: x).collect())
    )
    .groupBy("endpoint")
    .agg(F.countDistinct("user_id").alias("get_only_users"))
)

# Get the maximum count
max_count = counts_df.agg(F.max("get_only_users")).collect()[0][0]

# Filter to endpoints with the maximum count and sort
result = (
    counts_df.filter(F.col("get_only_users") == max_count)
    .orderBy("endpoint")
)

result.show()
