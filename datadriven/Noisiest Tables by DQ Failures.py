"""PySpark solution for: Noisiest Tables by DQ Failures
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter checks that failed and group by table to aggregate
failed_checks = dq_checks.filter(F.col("passed") == 0).groupBy("tbl_name").agg(
    F.count("*").alias("failure_count"),  # Count of failed checks per table
    F.max("fail_pct").alias("max_fail_pct")  # Max failure percentage per table
)

# Filter out tables with zero failures (Implicitly handled since we're only aggregating failed checks)
# However, to ensure no rows with NULL (in case of zero fail_pct but this is avoided by initial filter)
# we add a filter, though in this context, it's more about ensuring max_fail_pct is not NULL
non_zero_failures = failed_checks.filter(F.col("failure_count") > 0)

# Sort the results by failure count in descending order
sorted_failures = non_zero_failures.orderBy(F.col("failure_count").desc())

# Optionally, if you want to assign a rank (though not explicitly requested, added for completeness)
# ranked = sorted_failures.withColumn("rank", F.dense_rank().over(Window.orderBy(F.col("failure_count").desc())))

sorted_failures.show()
