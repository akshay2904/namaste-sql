"""PySpark solution for: Seen or Ignored
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Standardize platform case
push_notifs = push_notifs.withColumn("platform", F.lower("platform"))

# Calculate open ratio per platform
open_ratio_df = (
    push_notifs
    .groupby("platform")
    .agg(
        (F.sum("opened") / F.count("*")).alias("open_ratio")
    )
    .orderBy(F.col("open_ratio").desc())
)

open_ratio_df.show()
