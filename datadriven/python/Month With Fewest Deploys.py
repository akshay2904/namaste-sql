"""PySpark solution for: Month With Fewest Deploys
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Extract month number from deploy_at using the specified format (in UTC timezone)
# Note: STRFTIME('%m', deploy_at) in SQL extracts the month from timestamp
deploy_logs_with_month = deploy_logs.withColumn(
    "month_num", 
    F.month(F.to_utc_timestamp(F.col("deploy_at"), "UTC"))  # SQL STRFTIME uses local time by default; this assumes UTC as default
)

# Group by month and count deployments, order by count ascending, take first
result = (
    deploy_logs_with_month
    .groupBy("month_num")
    .agg(F.count("*").alias("deploy_count"))
    .orderBy(F.col("deploy_count").asc())
    .limit(1)
)

result.show()
