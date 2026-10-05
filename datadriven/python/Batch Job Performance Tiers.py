"""PySpark solution for: Batch Job Performance Tiers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    batch_jobs
    .groupBy("job_name")
    .agg(F.sum("rows_done").alias("total_rows"))
    .withColumn(
        "performance_tier",
        F.when(F.col("total_rows") >= 30000, "Outstanding")
         .when(F.col("total_rows") >= 20000, "Satisfactory")
         .when(F.col("total_rows") >= 10000, "Unsatisfactory")
         .otherwise("Poor")
    )
    .orderBy(F.col("total_rows").desc())
)

result.show()
