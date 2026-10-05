"""PySpark solution for: The Switchboard
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Define window partitioned by flag_name, ordered by updated desc, flag_id desc
window_spec = Window.partitionBy("flag_name").orderBy(
    F.col("updated").desc(), F.col("flag_id").desc()
)

# Get the latest record per flag using row_number
latest = feat_flags.withColumn(
    "rn", F.row_number().over(window_spec)
).filter(F.col("rn") == 1)

# Compute enabled and disabled indicators, order by flag_name
result = latest.select(
    F.col("flag_name"),
    F.col("enabled").alias("enabled_flag"),
    (1 - F.col("enabled")).alias("disabled_flag")
).orderBy("flag_name")

# Show result
result.show(truncate=False)
