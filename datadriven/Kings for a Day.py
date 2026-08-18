"""PySpark solution for: Kings for a Day
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Extract date from started timestamp and add rank within each date
ranked = batch_jobs.filter(
    F.col("rows_done").isNotNull()
).withColumn(
    "job_date", F.to_date(F.col("started"))
).withColumn(
    "rnk", F.rank().over(
        Window.partitionBy("job_date").orderBy(F.col("rows_done").desc())
    )
)

# Filter for highest row count per date and order by date
result = ranked.filter(
    F.col("rnk") == 1
).select(
    "job_date", "job_name", "rows_done"
).orderBy("job_date")

result.show()
