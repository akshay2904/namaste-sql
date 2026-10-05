"""PySpark solution for: Top Pattern Matches
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Pattern matching using regex (equivalent to LIKE '___-____%')
pattern_match = F.regexp_extract("message", r"^\d{3}-\d{4,}", 0).isNotNull()

# Filter, group, and aggregate matching logs
server_matches = server_logs.filter(pattern_match).groupBy("server_name").agg(F.count("*").alias("match_count"))

# Sort in descending order by match count and limit to 10
result = server_matches.orderBy(F.col("match_count").desc()).limit(10)

result.show()
