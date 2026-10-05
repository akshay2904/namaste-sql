"""PySpark solution for: Top Framework by Deployments
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

deployed_counts = ml_models.filter(F.col("status") == "Deployed") \
    .groupBy("mdl_name", "framework") \
    .count() \
    .withColumnRenamed("count", "deploy_count")

top_model = deployed_counts.orderBy(F.col("deploy_count").desc(), F.col("mdl_name").asc()) \
    .limit(1)

result = top_model.select("framework")
