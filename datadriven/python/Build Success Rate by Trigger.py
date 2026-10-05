"""PySpark solution for: Build Success Rate by Trigger
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

result = (ci_builds
    .groupBy("trigger")
    .agg(
        F.count("*").alias("total_builds"),
        (F.sum(F.when(F.col("status") == "success", 1).otherwise(0)) 
         / F.count("*")).alias("success_rate")
    )
    .select("trigger", "total_builds", "success_rate")
)
