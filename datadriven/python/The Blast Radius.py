"""PySpark solution for: The Blast Radius
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join deploy_logs with svc_health on svc_name
joined_df = deploy_logs.join(svc_health, deploy_logs.svc_name == svc_health.svc_name)

# Group by lowercased author, calculate average latency, round to 2 decimals
result_df = (
    joined_df
    .withColumn("author", F.lower("author"))
    .groupBy("author")
    .agg(F.round(F.avg("latency"), 2).alias("avg_score"))
    .orderBy(F.desc("avg_score"), F.asc("author"))
)

result_df.show()
