"""PySpark solution for: Deployments per Environment
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by env_name and count the rows in each group, alias the count
deploy_counts = (
    deploy_logs
    .groupBy("env_name")
    .agg(F.count("*").alias("deploy_count"))
)

deploy_counts.show()
