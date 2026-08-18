"""PySpark solution for: Best Accuracy to Training Time Ratio
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Convert train_at to epoch seconds and calculate ratio
result = (
    ml_models
    .filter(F.col("accuracy").isNotNull())
    .withColumn(
        "ratio",
        F.col("accuracy") / F.unix_timestamp(F.col("train_at"))
    )
    .select("mdl_name", "accuracy", "train_at", "ratio")
    .orderBy(F.col("ratio").desc())
    .limit(1)
)

result.show()
