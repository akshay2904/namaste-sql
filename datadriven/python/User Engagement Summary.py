"""PySpark solution for: User Engagement Summary
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Aggregate sessions and queries with filters for non-null user_id
session_counts = user_sessions.filter(user_sessions.user_id.isNotNull()).groupBy("user_id").agg(F.count("session_id").alias("total_sessions"))
query_counts = search_queries.filter(search_queries.user_id.isNotNull()).groupBy("user_id").agg(F.count("query_id").alias("total_queries"))

# Get all unique user_ids from both aggregations
all_users = session_counts.select("user_id").unionByName(query_counts.select("user_id"))

# Join all users with sessions and queries, handling nulls with coalesce
result = (
    all_users
    .join(session_counts.alias("sc"), "user_id", "leftouter")
    .join(query_counts.alias("qc"), "user_id", "leftouter")
    .select(
        "user_id",
        F.coalesce("sc.total_sessions", F.lit(0)).alias("total_sessions"),
        F.coalesce("qc.total_queries", F.lit(0)).alias("total_queries")
    )
    .orderBy("user_id")
)

result.show()
