"""PySpark solution for: Response Buckets
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import when, col

api_calls \
    .filter(col("latency").isNotNull()) \
    .select(
        "endpoint",
        "latency",
        when(col("latency") < 100, "fast")
        .when(col("latency") <= 500, "normal")
        .otherwise("slow")
        .alias("latency_label")
    ) \
    .show()
