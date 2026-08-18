"""PySpark solution for: Completion Rate
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

result = (
    orders
    .filter(F.col("region").isNotNull())
    .groupBy("region")
    .agg(
        F.round(
            100 * F.sum(F.when(F.col("status") == "Completed", 1).otherwise(0)) / F.count("*"),
            2
        ).alias("completion_pct")
    )
    .orderBy("region")
)
