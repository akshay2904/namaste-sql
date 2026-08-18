"""PySpark solution for: Top Batch Job Under Priority 1
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter priority-1 jobs
priority_1_jobs = batch_jobs.filter(batch_jobs.priority == 1)

# Max rows done in priority-1 jobs
max_rows_done = priority_1_jobs.agg(F.max("rows_done").alias("max_rows")) \
                   .collect()[0].max_rows

# Find all jobs with max rows done
result = priority_1_jobs.filter(priority_1_jobs.rows_done == max_rows_done) \
                       .select("job_id", "job_name", "rows_done") \
                       .orderBy("job_id")
