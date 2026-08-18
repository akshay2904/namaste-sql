"""PySpark solution for: Balance of Arms
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by exp_name and aggregate distinct user counts for control and treatment
result = (experiments
    .groupBy("exp_name")
    .agg(
        F.countDistinct(F.when(F.col("variant") == "control", F.col("user_id"))).alias("control_users"),
        F.countDistinct(F.when(F.col("variant") != "control", F.col("user_id"))).alias("treatment_users")
    )
    .withColumn(
        "treatment_to_control_ratio",
        # Guard against division by zero with NULLIF equivalent
        F.when(
            F.col("control_users") != 0,
            F.round(F.col("treatment_users") / F.col("control_users"), 3)
        )
    )
    .orderBy("exp_name")
)

result.show(truncate=False)
