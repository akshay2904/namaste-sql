"""PySpark solution for: Parallel Traces
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    experiments.alias("e1")
    .join(
        experiments.alias("e2"),
        (F.col("e1.exp_name") == F.col("e2.exp_name"))
        & (F.col("e1.platform") == F.col("e2.platform"))
        & (F.col("e1.variant") != F.col("e2.variant"))
        & (F.col("e1.user_id") < F.col("e2.user_id")),
        "inner"
    )
    .select(
        F.col("e1.user_id").alias("user_id1"),
        F.col("e2.user_id").alias("user_id2")
    )
    .distinct()
    .orderBy("user_id1", "user_id2")
)
