"""PySpark solution for: Name Recognition
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Bucket each service based on keywords in its name
result = (
    svc_health
    .select(
        F.col("svc_name"),
        F.when(F.col("svc_name").contains("api"), "api_service")
         .when(F.col("svc_name").contains("cache") | F.col("svc_name").contains("redis"), "cache_service")
         .when(F.col("svc_name").contains("db") | F.col("svc_name").contains("postgres"), "database")
         .otherwise("other")
         .alias("category")
    )
    .distinct()
    .limit(100)
)

result.show()
