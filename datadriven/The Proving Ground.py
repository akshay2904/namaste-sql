"""PySpark solution for: The Proving Ground
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter for year 2026 and non-null accuracy
filtered = ml_models.filter(
    (F.year("train_at") == 2026) & (F.col("accuracy").isNotNull())
)

# Normalize framework name, compute average accuracy, and sort
result = (
    filtered.withColumn("framework", F.lower(F.col("framework")))
    .groupBy("framework")
    .agg(F.avg("accuracy").alias("avg_accuracy"))
    .orderBy(F.col("avg_accuracy").desc(), F.col("framework").asc())
)

result.show()
