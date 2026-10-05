"""PySpark solution for: Then and Now
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql import Window

# Filter to versions where both accuracy and train_at are recorded
counted = ml_models.filter(
    F.col("accuracy").isNotNull() & F.col("train_at").isNotNull()
)

# Window for latest version per model
latest_window = Window.partitionBy("model_id").orderBy(F.col("train_at").desc())

# Add latest accuracy and rank per row
with_latest = counted.withColumn(
    "latest_accuracy", F.first("accuracy").over(latest_window)
).withColumn(
    "rn", F.row_number().over(latest_window)
)

# Identify whether a row is the most recent and mark earlier rows
earlier = with_latest.filter(F.col("rn") > 1)
latest_rows = with_latest.filter(F.col("rn") == 1)

# Average accuracy across all counted versions per model
avg_all = counted.groupBy("model_id", "mdl_name").agg(
    F.round(F.avg("accuracy"), 2).alias("avg_lifetime_accuracy")
)

# Average accuracy of earlier versions (non-latest) per model
avg_earlier = earlier.groupBy("model_id").agg(
    F.round(F.avg("accuracy"), 2).alias("avg_earlier_accuracy")
)

# Join latest info with averages and compute the difference
result = latest_rows.join(avg_all, ["model_id", "mdl_name"], "inner") \
    .join(avg_earlier, "model_id", "left") \
    .withColumn(
        "avg_earlier_accuracy",
        F.coalesce("avg_earlier_accuracy", F.lit(0.0))
    ) \
    .withColumn(
        "difference",
        F.round(F.col("latest_accuracy") - F.col("avg_earlier_accuracy"), 2)
    ) \
    .select(
        F.col("mdl_name").alias("model_name"),
        F.col("avg_lifetime_accuracy"),
        F.round(F.col("latest_accuracy"), 2).alias("latest_accuracy"),
        "difference"
    ) \
    .orderBy("model_name")

result.show()
