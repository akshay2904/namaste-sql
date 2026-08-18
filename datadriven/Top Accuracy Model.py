"""PySpark solution for: Top Accuracy Model
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import col, max as _max

# Find the maximum accuracy
max_accuracy = ml_models.agg(_max("accuracy").alias("max_accuracy")).collect()[0].max_accuracy

# Filter models with the maximum accuracy and select required columns
result = (
    ml_models
    .filter(col("accuracy") == max_accuracy)
    .select("mdl_name", "accuracy")
    .orderBy("mdl_name")
)

# Show the result
result.show()
