"""PySpark solution for: Campaign Cost Effectiveness
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter to campaigns between 2025 and 2026 inclusive
filtered = ad_impressions.filter(
    (F.year("impression_time") >= 2025) & (F.year("impression_time") <= 2026)
)

# Calculate revenue per click, handling divide-by-zero with NULLIF equivalent
result = (
    filtered.groupBy("ad_campaign")
    .agg(
        (F.sum("revenue") * 1.0 / F.when(F.sum("clicked") == 0, None).otherwise(F.sum("clicked"))).alias("revenue_per_click")
    )
    .orderBy(F.desc("revenue_per_click"), F.asc("ad_campaign"))
)

result.show(truncate=False)
