"""PySpark solution for: Worst Table Per Year by DQ Failures
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter failed checks and extract year from run_at timestamp
df_failed = dq_checks.filter(F.col("passed") == 0).withColumn(
    "year", F.date_format(F.col("run_at"), "yyyy")
)

# Count failures per year and table
df_counts = df_failed.groupBy("year", "tbl_name").agg(
    F.count("*").alias("fail_count")
)

# Rank tables by failure count within each year
window_spec = Window.partitionBy("year").orderBy(F.col("fail_count").desc())

# Filter for the table with the most failures in each year
result = (
    df_counts.withColumn("rn", F.row_number().over(window_spec))
    .filter(F.col("rn") == 1)
    .select("year", "tbl_name", "fail_count")
    .orderBy("year")
)
