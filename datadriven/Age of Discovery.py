"""PySpark solution for: Age of Discovery
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    search_queries
    .join(users, "user_id")
    .filter(users.age_bucket.isNotNull())
    .groupBy(users.age_bucket)
    .agg(
        F.count("*").alias("total_searches"),
        F.sum(F.when(search_queries.clicked_result.isNotNull(), 1).otherwise(0)).alias("successful_searches")
    )
    .withColumn("success_rate", F.col("successful_searches") / F.col("total_searches"))
    .orderBy("age_bucket")
)

result.show()
