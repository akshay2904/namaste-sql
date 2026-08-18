"""PySpark solution for: Proof of Presence
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    push_notifs_2fa.filter(F.col("status") == "delivered")
    .groupBy("platform")
    .agg(
        F.round(
            F.sum(F.when(F.col("opened") == 1, 1).otherwise(0)) / F.count("*"),
            2,
        ).alias("confirmation_rate")
    )
    .orderBy(F.col("confirmation_rate").desc())
)
