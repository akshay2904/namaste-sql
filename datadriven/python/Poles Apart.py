"""PySpark solution for: Poles Apart
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter tokens that have been used at least once
used_tokens = api_tokens.filter(F.col("last_used").isNotNull())

# Get max and min request counts from used tokens
max_requests = used_tokens.agg(F.max("requests")).collect()[0][0]
min_requests = used_tokens.agg(F.min("requests")).collect()[0][0]

# Filter for tokens matching either extreme, order by requests descending
result = used_tokens.filter(
    (F.col("requests") == max_requests) | (F.col("requests") == min_requests)
).select("token_id", "requests").orderBy(F.col("requests").desc())

result.show()
