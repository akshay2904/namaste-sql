"""PySpark solution for: Who Stayed
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define cohorts
cohorts = users.select("user_id", F.expr("substr(signup_date, 1, 7)").alias("cohort_month"))

# Calculate cohort sizes
cohort_sizes = cohorts.groupBy("cohort_month").agg(F.count("*").alias("cohort_size"))

# Identify active months for each user
activity = user_sessions.select("user_id", F.expr("substr(session_start, 1, 7)").alias("active_month")).distinct()

# Calculate months since signup for active users
active_cohorts = cohorts.join(activity, "user_id") \
    .withColumn("months_since_signup", (F.year("active_month") - F.year("cohort_month")) * 12 + (F.month("active_month") - F.month("cohort_month"))) \
    .filter(F.col("months_since_signup") >= 0)

# Calculate retention rate
retention_rates = active_cohorts.join(cohort_sizes, "cohort_month") \
    .groupBy("cohort_month", "months_since_signup", "cohort_size") \
    .agg(F.countDistinct("user_id").alias("distinct_user_id")) \
    .withColumn("retention_rate", F.col("distinct_user_id").cast("double") / F.col("cohort_size")) \
    .orderBy("cohort_month", "months_since_signup") \
    .select("cohort_month", "months_since_signup", "retention_rate")
