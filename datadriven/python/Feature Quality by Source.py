"""PySpark solution for: Feature Quality by Source
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Identify sources with high-null features
high_null_sources = (
    ml_features
    .filter(F.col("null_pct") > 20)
    .select("source")
    .distinct()
    .alias("h")
)

# Identify sources with low-null features
low_null_sources = (
    ml_features
    .filter(F.col("null_pct") < 2)
    .select("source")
    .distinct()
    .alias("l")
)

# Join to find sources that have both high-null and low-null features
qualifying_sources = (
    high_null_sources
    .join(low_null_sources, on="source", how="inner")
)

# Count features in each bucket for qualifying sources
result = (
    ml_features
    .join(qualifying_sources, on="source", how="inner")
    .groupBy("source")
    .agg(
        F.countDistinct(F.when(F.col("null_pct") > 20, F.col("feat_name"))).alias("high_null_count"),
        F.countDistinct(F.when(F.col("null_pct") < 2, F.col("feat_name"))).alias("low_null_count")
    )
    .select("source", "high_null_count", "low_null_count")
)
