"""PySpark solution for: The Company You Keep
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Users who share an experiment with at least one other user
shared_experiments = (
    experiments.alias("e1")
    .join(experiments.alias("e2"), 
          (F.col("e1.exp_name") == F.col("e2.exp_name")) & 
          (F.col("e1.user_id") != F.col("e2.user_id")))
    .select(F.col("e1.exp_name").alias("exp_name"))
    .distinct()
)

co_enrolled_users = (
    experiments.join(shared_experiments, "exp_name")
    .select("user_id")
    .distinct()
)

result = (
    user_sessions.join(co_enrolled_users, "user_id")
    .withColumn("session_date", F.to_date("session_start"))
    .withColumn("day_of_week", F.dayofweek("session_start"))
    .filter(F.col("day_of_week") == 6)  # Friday (dayofweek: Sunday=1, so Friday=6)
    .groupBy("session_date")
    .agg(F.count("*").alias("total_sessions"))
    .orderBy("session_date")
)

result.select("session_date", "total_sessions").show()
