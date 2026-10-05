"""PySpark solution for: Who Stayed
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Filter sessions before the cutoff date and get distinct user/dates
daily = user_sessions.filter(F.to_date(F.col("session_start")) <= F.lit("2026-08-10")) \
    .select("user_id", F.to_date("session_start").alias("session_day")) \
    .distinct()

# Add a row number per user ordered by date
window_spec = Window.partitionBy("user_id").orderBy("session_day")
numbered = daily.withColumn("rn", F.row_number().over(window_spec))

# Calculate the streak group by subtracting the row number from the date
streaks = numbered.withColumn(
    "grp", F.date_sub(F.col("session_day"), F.col("rn"))
).groupBy("user_id", "grp").agg(F.count("*").alias("streak_len"))

# Get the max streak length per user
max_streaks = streaks.groupBy("user_id").agg(F.max("streak_len").alias("streak_length"))

# Rank users by their max streak length and keep top 3
rank_window = Window.orderBy(F.col("streak_length").desc())
ranked = max_streaks.withColumn("rnk", F.dense_rank().over(rank_window)) \
    .filter(F.col("rnk") <= 3)

# Output only user_id and streak_length, ordered by streak length descending
result = ranked.select("user_id", "streak_length").orderBy(F.col("streak_length").desc())

result.show(truncate=False)
