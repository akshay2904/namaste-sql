"""PySpark solution for: Radio Silence
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Join experiments with users on user_id
result = (
    experiments.alias("e")
    .join(users.alias("u"), F.col("e.user_id") == F.col("u.user_id"), "inner")
    # Filter for control variant, android platform, and non-active accounts
    .filter(
        (F.col("e.variant") == "control") &
        (F.col("e.platform") == "android") &
        (F.col("u.account_status") != "active")
    )
    # Select required columns
    .select(
        F.col("e.user_id"),
        F.col("u.age_bucket"),
        F.col("e.platform"),
        F.col("e.variant")
    )
    # Order by experiment creation date (oldest first)
    .orderBy("e.created")
)

result.show()
