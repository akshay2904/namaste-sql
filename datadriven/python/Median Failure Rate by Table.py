"""PySpark solution for: Median Failure Rate by Table
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter out null fail_pct values
filtered_df = dq_checks.filter(F.col("fail_pct").isNotNull())

# Define window partitioned by tbl_name ordered by fail_pct
window_spec = Window.partitionBy("tbl_name").orderBy("fail_pct")

# Add row number and count for each partition
df_with_rn = filtered_df.withColumn(
    "rn", F.row_number().over(window_spec)
).withColumn(
    "cnt", F.count("*").over(Window.partitionBy("tbl_name"))
)

# Filter to the median rows (middle one or two rows for even count)
median_rows = df_with_rn.filter(
    (F.col("rn") == ((F.col("cnt") + 1) / 2)) |
    (F.col("rn") == ((F.col("cnt") + 2) / 2))
)

# Average the median values per table and round
result = median_rows.groupBy("tbl_name").agg(
    F.round(F.avg("fail_pct")).alias("median_fail_pct")
).orderBy(F.col("median_fail_pct").desc(), F.col("tbl_name"))

result.show()
