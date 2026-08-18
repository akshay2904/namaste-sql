"""PySpark solution for: The Ones Who Clicked
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Derive signup cohort year
cohort = users.select("user_id", F.year("signup_date").alias("signup_cohort"))

# Join with search queries and aggregate
result = (
    search_queries
    .join(cohort, "user_id", "left_outer")  # Handle users without signup_date (if any)
    .groupBy("signup_cohort")
    .agg(
        F.count("*").alias("total_searches"),
        F.sum(F.col("clicked_result").isNotNull().cast("integer")).alias("successful_searches")
    )
    .withColumn("success_rate", F.col("successful_searches") / F.col("total_searches"))
    .orderBy("signup_cohort")
)

# Display the result
result.show(truncate=False)
