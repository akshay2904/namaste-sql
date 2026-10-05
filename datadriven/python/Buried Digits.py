"""PySpark solution for: Buried Digits
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for exact lowercase 'staging' environment
deploy_logs_filtered = deploy_logs.filter(F.col("env_name") == "staging")

# Remove 'v', '.', and '-' from version, then cast to integer
result = deploy_logs_filtered.select(
    "svc_name",
    F.regexp_replace(
        F.regexp_replace(
            F.regexp_replace(F.col("version"), "v", ""),
            "\\.",
            ""
        ),
        "-",
        ""
    ).cast("int").alias("version_num")
)
