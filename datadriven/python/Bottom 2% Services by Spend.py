"""PySpark solution for: Bottom 2% Services by Spend
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter for May 2026 and aggregate by service
monthly_totals = (
    cloud_costs
    .filter(
        (F.col("bill_date").substr(1, 4) == "2026") &
        (F.col("bill_date").substr(6, 2) == "05")
    )
    .groupBy("svc_name")
    .agg(F.sum("amount").alias("total_spend"))
)

# Assign percentile bucket using NTILE over total_spend ordering
window_spec = Window.orderBy("total_spend")
ranked = monthly_totals.withColumn(
    "percentile_bucket",
    F.ntile(50).over(window_spec)
)

# Select bottom bucket and sort ascending
result = (
    ranked
    .filter(F.col("percentile_bucket") == 1)
    .select("svc_name", "total_spend")
    .orderBy("total_spend")
)
