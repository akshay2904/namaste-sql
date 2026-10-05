"""PySpark solution for: First Deploy Attribution
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Add row number partitioned by author and svc_name, ordered by deploy_at
window_spec = Window.partitionBy("author", "svc_name").orderBy("deploy_at")
deploy_with_rn = deploy_logs.withColumn("rn", F.row_number().over(window_spec))

# Aggregate by svc_name
result = (
    deploy_with_rn.groupBy("svc_name")
    .agg(
        F.count("*").alias("total_deploys"),
        F.sum(F.when(F.col("rn") == 1, 1).otherwise(0)).alias("first_time_deploys")
    )
    .orderBy("svc_name")
)

result.show()
