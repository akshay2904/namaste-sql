"""PySpark solution for: The Path Not Taken
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql.window import Window

# Filter for users who visited new_editor and get their first visit
first_new = (
    page_views
    .filter(F.col("page_url") == "new_editor")
    .groupBy("user_id")
    .agg(F.min("viewed_at").alias("first_new_date"))
)

# Anti-join: keep users who never visited classic_editor before their first new_editor visit
# Need to join with viewed_at < first_new_date condition
result = (
    first_new
    .join(
        page_views.filter(F.col("page_url") == "classic_editor"),
        on=["user_id"],
        how="left_anti"
    )
    .select("user_id")
)

# However, the above join doesn't include the timestamp condition,
# so we need to use a different approach:
# Create a temp view of classic_editor visits and check with a condition

# Correct approach using broadcast hint or cross join with filter
classic_visits = page_views.filter(F.col("page_url") == "classic_editor").select("user_id", "viewed_at")

# Use a cross join with condition, then filter
result = (
    first_new
    .crossJoin(
        classic_visits.select(
            F.col("user_id").alias("classic_user_id"),
            F.col("viewed_at").alias("classic_viewed_at")
        )
    )
    .filter(
        (F.col("user_id") == F.col("classic_user_id")) &
        (F.col("classic_viewed_at") < F.col("first_new_date"))
    )
    .select("user_id")
    .distinct()
)

# Then anti-join to get users without any prior classic visits
all_new_users = first_new.select("user_id")
users_with_prior_classic = result.select("user_id")

result = all_new_users.join(users_with_prior_classic, on="user_id", how="left_anti")

result.select("user_id").show()
