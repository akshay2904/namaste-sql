"""PySpark solution for: All Known Endpoints
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Combine endpoints from both tables
all_endpoints = api_calls.select("endpoint").union(rate_limits.select("endpoint"))

# Normalize endpoints by removing trailing slash if present and not just root "/"
result = all_endpoints.select(
    F.when(
        (F.length("endpoint") > 1) & F.col("endpoint").endswith("/"),
        F.expr("rtrim(endpoint, '/')")
    ).otherwise(F.col("endpoint")).alias("endpoint")
).distinct().orderBy("endpoint")

result.show(truncate=False)
