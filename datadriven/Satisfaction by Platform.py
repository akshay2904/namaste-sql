"""PySpark solution for: Satisfaction by Platform
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import col, round, avg

# Filter users in the 25-34 age cohort
users_25_34 = users.filter(col("age_bucket") == "25-34")

# Join experiments with users in the 25-34 age cohort
experiments_25_34 = experiments.join(users_25_34, on="user_id", how="inner")

# Group by platform and calculate average outcome
avg_satisfaction = experiments_25_34.groupBy("platform").agg(
    round(avg("outcome")).alias("avg_satisfaction")
)

# Display the result
avg_satisfaction.show()
