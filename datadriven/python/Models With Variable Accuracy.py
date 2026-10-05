"""PySpark solution for: Models With Variable Accuracy
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    ml_models
    .groupBy("mdl_name")
    .agg(
        F.min("accuracy").alias("min_accuracy"),
        F.max("accuracy").alias("max_accuracy")
    )
    .filter(F.col("min_accuracy") != F.col("max_accuracy"))
    .orderBy("mdl_name")
    .select("mdl_name", "min_accuracy", "max_accuracy")
)
