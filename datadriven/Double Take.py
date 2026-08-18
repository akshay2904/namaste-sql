"""PySpark solution for: Double Take
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Group by and filter duplicates
pair_counts = (
    dq_checks
    .groupBy("tbl_name", "col_name")
    .agg(F.count("*").alias("duplicate_count"))
    .filter(F.col("duplicate_count") > 1)
)

# Window for rank
window_spec = Window.orderBy(F.col("duplicate_count").desc())

# Window for total sum (unbounded)
total_spec = Window.orderBy(F.lit(1)).rowsBetween(Window.unboundedPreceding, Window.unboundedFollowing)

result = (
    pair_counts
    .withColumn("dup_rank", F.rank().over(window_spec))
    .withColumn(
        "pct_of_dups",
        F.round(100 * F.col("duplicate_count") / F.sum("duplicate_count").over(total_spec), 2)
    )
    .select("tbl_name", "col_name", "duplicate_count", "dup_rank", "pct_of_dups")
    .orderBy(F.col("duplicate_count").desc(), "tbl_name", "col_name")
)

result.show()
