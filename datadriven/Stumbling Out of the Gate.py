"""PySpark solution for: Stumbling Out of the Gate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Window to order training runs for each model version
window_spec = Window.partitionBy("mdl_name", "version").orderBy("train_at")

# Filter out runs without accuracy scores, then identify the very first run per model version
first_runs = (
    ml_models
    .filter(F.col("accuracy").isNotNull())
    .withColumn("rn", F.row_number().over(window_spec))
    .filter(F.col("rn") == 1)
)

# Calculate percentage of first runs that failed
result = first_runs.select(
    (
        F.sum(F.when(F.lower(F.col("status")) == "failed", 1).otherwise(0)).cast("double") * 100.0 / F.count("*")
    ).alias("pct_failed_first_run")
)
