"""PySpark solution for: Authors Deploying to Dev and Production
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter to dev/production environments (case-insensitive)
filtered_df = deploy_logs.filter(
    F.lower(F.col("env_name")).isin("dev", "production")
)

# Group by author and count distinct normalized environments
result_df = (
    filtered_df
    .withColumn("normalized_env", F.lower(F.col("env_name")))
    .groupBy("author")
    .agg(F.countDistinct("normalized_env").alias("env_count"))
    .filter(F.col("env_count") == 2)
    .orderBy("author")
)

result_df.select("author", "env_count").show()
