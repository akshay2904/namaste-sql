"""PySpark solution for: API Call Distribution Fraction
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Normalize method to uppercase and select relevant columns
normalized = api_calls.select(
    F.upper(F.col("method")).alias("method"),
    F.col("status")
)

# Aggregate by method and status, compute fraction using window function
result = (
    normalized
    .groupBy("method", "status")
    .agg(F.count("*").alias("cnt"))
    .withColumn(
        "fraction",
        F.col("cnt") / F.sum("cnt").over(Window.orderBy())
    )
    .select("method", "status", "fraction")
    .orderBy(F.col("fraction").desc(), F.col("method").asc(), F.col("status").asc())
)

result.show()
