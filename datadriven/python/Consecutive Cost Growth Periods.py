"""PySpark solution for: Consecutive Cost Growth Periods
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Aggregate total amount per bill_date
monthly = (
    cloud_costs
    .filter(F.col("amount").isNotNull())
    .groupBy("bill_date")
    .agg(F.sum("amount").alias("total_amount"))
)

# Window spec ordered by bill_date
window_spec = Window.orderBy("bill_date")

# Add previous amount and row number
with_lag = monthly.withColumn(
    "prev_amount", F.lag("total_amount").over(window_spec)
).withColumn("rn", F.row_number().over(window_spec))

# Keep only rows where total increased compared to previous
increasing = with_lag.filter(F.col("total_amount") > F.col("prev_amount"))

# Group consecutive rows into streaks: rn - row_number within increasing set
streak_groups = increasing.withColumn(
    "grp", F.col("rn") - F.row_number().over(Window.orderBy("bill_date"))
)

# Compute start date and streak length, keep streaks with length >= 2
result = (
    streak_groups
    .groupBy("grp")
    .agg(
        F.min("bill_date").alias("start_date"),
        F.count("*").alias("streak_len")
    )
    .filter(F.col("streak_len") >= 2)
    .orderBy("start_date")
    .select("start_date", "streak_len")
)

result.show()
