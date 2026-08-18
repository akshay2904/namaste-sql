"""PySpark solution for: Model Training Completion Rate
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = ml_models.groupBy("mdl_name").agg(
    F.round(F.avg("accuracy"), 4).alias("avg_accuracy"),
    F.round(F.count("accuracy") * 100.0 / F.count("*"), 2).alias("completion_rate")
).select("mdl_name", "avg_accuracy", "completion_rate")

result
