"""PySpark solution for: Who Stayed
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.types import DoubleType

# Create base DataFrame with distinct service, month, region combinations
svc_region_month = svc_health.select(
    "svc_name",
    F.date_format(F.to_timestamp("checked"), "yyyy-MM").alias("month"),
    "region"
).distinct()

# Filter to only December 2025 and January 2026 for the current month
current = svc_region_month.filter(F.col("month").isin("2025-12", "2026-01"))

# Join with future months for the same service and region
joined = current.alias("c").join(
    svc_region_month.alias("f"),
    (F.col("c.svc_name") == F.col("f.svc_name")) & 
    (F.col("c.region") == F.col("f.region")) & 
    (F.col("f.month") > F.col("c.month")),
    "left"
)

# Calculate retention percentage
result = joined.groupBy("c.svc_name", "c.month").agg(
    F.round(
        100.0 * F.countDistinct(F.when(F.col("f.region").isNotNull(), F.col("c.region"))) / 
        F.countDistinct(F.col("c.region")),
        2
    ).alias("retention_pct")
).select(
    F.col("c.svc_name").alias("svc_name"),
    F.col("c.month").alias("month"),
    "retention_pct"
).orderBy("c.svc_name", "c.month")

result.show()
