"""PySpark solution for: Ebb and Flow
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Aggregate revenue by month
monthly = (
    transactions
    .withColumn("month", F.date_format("transaction_date", "yyyy-MM"))
    .groupBy("month")
    .agg(F.sum("total_amount").alias("revenue"))
)

# Add previous month's revenue using window function
window_spec = Window.orderBy("month")
sequenced = monthly.withColumn("prev_revenue", F.lag("revenue").over(window_spec))

# Compute percentage change with safety checks
result = (
    sequenced
    .select(
        "month",
        F.round("revenue", 2).alias("revenue"),
        F.when(
            F.col("prev_revenue").isNull() | (F.col("prev_revenue") == 0),
            F.lit(None)
        ).otherwise(
            F.round((F.col("revenue") - F.col("prev_revenue")) * 100.0 / F.col("prev_revenue"), 2)
        ).alias("pct_change")
    )
    .orderBy("month")
)
result.show(truncate=False)
