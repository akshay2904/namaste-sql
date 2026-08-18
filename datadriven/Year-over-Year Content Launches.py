"""PySpark solution for: Year-over-Year Content Launches
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Calculate net change in content published in 2026 vs 2025 for each creator
result = (
    content_items
    .filter(F.year(F.col("publish_date")).isin(2025, 2026))
    .groupBy("creator_id")
    .agg(
        (
            F.sum(F.when(F.year(F.col("publish_date")) == 2026, 1).otherwise(0)) -
            F.sum(F.when(F.year(F.col("publish_date")) == 2025, 1).otherwise(0))
        ).alias("net_difference")
    )
    .orderBy(F.col("net_difference").desc(), F.col("creator_id").asc())
)
