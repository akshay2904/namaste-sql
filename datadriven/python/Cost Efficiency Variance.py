"""PySpark solution for: Cost Efficiency Variance
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Compute service count per region
svc_per_region = (
    cloud_costs
    .groupBy("region")
    .agg(F.countDistinct("svc_name").alias("svc_count"))
)

# Join with cloud_costs to compute cost ratio per billing entry
with_ratio = (
    cloud_costs
    .join(svc_per_region, on="region", how="inner")
    .withColumn("ym", F.date_format(F.to_date("bill_date"), "yyyy-MM"))
    .withColumn("cost_ratio", F.col("amount") / F.col("svc_count"))
    .select("cost_id", "svc_name", "region", "amount", "bill_date", "ym", "cost_ratio")
)

# Compute monthly average ratio
monthly_avg = (
    with_ratio
    .groupBy("ym")
    .agg(F.avg("cost_ratio").alias("avg_ratio"))
)

# Compute absolute differences between individual ratios and monthly average
diffs = (
    with_ratio
    .join(monthly_avg, on="ym", how="inner")
    .withColumn("actual_ratio", F.col("cost_ratio"))
    .withColumn("monthly_average", F.col("avg_ratio"))
    .withColumn("abs_diff", F.abs(F.col("cost_ratio") - F.col("avg_ratio")))
)

# Aggregate per year-month
result = (
    diffs
    .groupBy("ym")
    .agg(
        F.avg("actual_ratio").alias("actual_ratio"),
        F.avg("monthly_average").alias("monthly_average"),
        F.avg("abs_diff").alias("avg_abs_difference")
    )
    .orderBy("ym")
)

result.show()
