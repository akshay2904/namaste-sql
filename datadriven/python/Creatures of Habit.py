"""PySpark solution for: Creatures of Habit
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window, functions as F

# Filter teams with more than 3 distinct services
large_teams = (
    cost_allocs
    .groupBy("team_name")
    .agg(F.countDistinct("svc_name").alias("distinct_svc"))
    .filter(F.col("distinct_svc") > 3)
)

# Get service counts for large teams only
svc_counts = (
    cost_allocs
    .join(large_teams.select("team_name"), "team_name")
    .groupBy("team_name", "svc_name")
    .agg(F.count("*").alias("cnt"))
)

# Rank services per team by count desc, then svc_name for tie-breaking
window_spec = Window.partitionBy("team_name").orderBy(F.desc("cnt"), F.col("svc_name"))
ranked = svc_counts.withColumn("rn", F.row_number().over(window_spec))

# Select top service per team
result = (
    ranked
    .filter(F.col("rn") == 1)
    .select("team_name", "svc_name", "cnt")
    .orderBy("team_name")
)
