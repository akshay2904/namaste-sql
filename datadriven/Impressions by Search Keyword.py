"""PySpark solution for: Impressions by Search Keyword
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter search terms containing 'laptop', deduplicate (search_term, user_id) pairs
search_subset = (
    search_queries
    .filter(F.col("search_term").contains("laptop"))
    .select("search_term", "user_id")
    .distinct()
)

# Join with ad_impressions on user_id and aggregate
result = (
    search_subset
    .join(ad_impressions, search_subset.user_id == ad_impressions.user_id, "inner")
    .groupBy(search_subset.search_term)
    .agg(F.count("*").alias("impression_count"))
    .orderBy(F.desc("impression_count"), F.asc("search_term"))
)

result.show()
