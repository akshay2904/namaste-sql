"""PySpark solution for: Job Status Duration
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

# Create window spec for finding next status change per job
window_spec = Window.partitionBy("job_id").orderBy("started")

# Calculate and aggregate durations per status
result = (
    batch_jobs
    .select(
        "job_id",
        "status",
        "started",
        F.lead("started").over(window_spec).alias("next_started")
    )
    .withColumn(
        "hours",
        F.when(
            F.col("next_started").isNotNull(),
            (F.unix_timestamp("next_started") - F.unix_timestamp("started")) / 3600.0
        ).otherwise(2.0)  # Last status per job assumed 2 hours
    )
    .groupBy("status")
    .agg(F.round(F.sum("hours"), 2).alias("total_hours"))
    .select("status", "total_hours")
)
