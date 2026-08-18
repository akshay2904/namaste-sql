"""PySpark solution for: Feature Name Intersection
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter records and aggregate counts/max dates per feature name
source_presence = (
    ml_features
    .filter(F.col("source").isNotNull())
    .groupBy("feat_name")
    .agg(
        F.sum(F.when(F.col("source") == "ad_impressions", 1).otherwise(0)).alias("ad_rows"),
        F.sum(F.when(F.col("source") == "search_queries", 1).otherwise(0)).alias("search_rows"),
        F.max(F.when(F.col("source") == "ad_impressions", F.col("updated"))).alias("last_seen_ad"),
        F.max(F.when(F.col("source") == "search_queries", F.col("updated"))).alias("last_seen_search")
    )
)

# Keep only features present in both sources
shared = source_presence.filter(
    (F.col("ad_rows") > 0) & (F.col("search_rows") > 0)
).select(
    "feat_name", "ad_rows", "search_rows", "last_seen_ad", "last_seen_search"
).orderBy("feat_name")

shared.show()
