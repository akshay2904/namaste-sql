"""PySpark solution for: Auth Endpoint Callers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter API calls containing 'auth' in endpoint, join with users, and select required columns
result = (
    api_calls
    .filter(F.col("endpoint").contains("auth"))
    .join(users, on="user_id", how="inner")
    .select(
        "user_id",
        "username",
        "email",
        "call_id",
        "endpoint"
    )
    .orderBy("user_id")
)

result.show()
