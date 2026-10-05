"""PySpark solution for: Loaded Dice
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Window specifications
w_total = Window.partitionBy()
w_cum = Window.orderBy("rollout", "flag_id").rowsBetween(Window.unboundedPreceding, Window.currentRow)

# Calculate total rollout across all valid flags
total_rollout = F.sum("rollout").over(w_total)

result = (
    feat_flags
    .filter(F.col("rollout").isNotNull())
    .select(
        "flag_id",
        "flag_name",
        "rollout",
        (F.col("rollout").cast("double") / total_rollout).alias("probability"),
        (F.sum(F.col("rollout").cast("double")).over(w_cum) / total_rollout).alias("cumulative_prob")
    )
    .orderBy("rollout", "flag_id")
)
