"""PySpark solution for: Average Accuracy by Framework
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter deployed models with version between 1.0 and 3.0 (after cleaning)
# Clean version: remove 'v' prefix and '-beta' suffix, then take only the first 3 chars for versions like '1.0.0'
cleaned_version = F.substring(
    F.regexp_replace(F.regexp_replace(F.col("version"), "v", ""), "-beta", ""),
    1, 3
).cast("float")

filtered = ml_models.filter(
    (F.lower(F.col("status")) == "deployed") &
    cleaned_version.between(1.0, 3.0)
)

# Group by framework and compute average accuracy
result = filtered.groupBy("framework").agg(
    F.avg("accuracy").alias("avg_accuracy")
).orderBy(F.desc("avg_accuracy"), "framework")

result.show()
