"""PySpark solution for: Active User Open Rate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Left join push_notifs with users to keep all notifications
df = push_notifs.join(users, on="user_id", how="left")

# Compute percentage of notifications sent to active accounts and opened
result = df.agg(
    (
        F.sum(
            F.when(
                (F.col("account_status") == "active") & (F.col("opened") == 1),
                1,
            ).otherwise(0)
        )
        * 100.0
        / F.count("*")
    ).alias("active_opened_pct")
)
