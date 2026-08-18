"""PySpark solution for: 7-Day Onboarding Conversion
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window
from pyspark.sql.types import DoubleType

# Filter experiments to first 7 days of January 2026
signups = experiments.filter(
    (F.to_date("created") >= F.lit("2026-01-01")) & 
    (F.to_date("created") <= F.lit("2026-01-07"))
).select(
    "user_id",
    "platform",
    F.to_date("created").alias("signup_date")
)

# Join with sessions within 7 days of signup and mark conversion
engagement = signups.join(
    user_sessions,
    (signups.user_id == user_sessions.user_id) & 
    (F.datediff(F.to_date(user_sessions.session_start), signups.signup_date) >= 0) &
    (F.datediff(F.to_date(user_sessions.session_start), signups.signup_date) <= 7),
    "left"
).groupBy(
    signups.platform,
    signups.signup_date,
    signups.user_id
).agg(
    F.max(
        F.when(F.col("session_duration_sec") > 0, 1).otherwise(0)
    ).alias("converted")
)

# Aggregate by platform and signup date
result = engagement.groupBy("platform", "signup_date").agg(
    F.count("user_id").alias("total_users"),
    F.sum("converted").alias("converted_users"),
    (F.sum("converted") / F.count("user_id") * 100).cast(DoubleType()).alias("conversion_rate")
).orderBy("platform", "signup_date")

result.show()
