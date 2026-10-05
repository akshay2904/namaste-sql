"""PySpark solution for: First and Last Peak Accuracy Dates
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F

# Find the highest accuracy value
max_accuracy = ml_models.agg(F.max("accuracy")).collect()[0][0]

# Filter rows with that accuracy and get min/max train_at
result = (
    ml_models
    .filter(F.col("accuracy") == max_accuracy)
    .agg(
        F.min("train_at").alias("first_date"),
        F.max("train_at").alias("last_date")
    )
)
