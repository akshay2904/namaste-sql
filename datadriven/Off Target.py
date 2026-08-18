"""PySpark solution for: Off Target
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Define window specification to calculate NTILE deciles based on distance from accuracy target
window_spec = Window.orderBy(F.abs(F.col("accuracy") - 0.95))

result = (
    ml_models.filter(F.col("train_at").between("2026-01-01", "2026-06-30"))
    .withColumn("decile", F.ntile(10).over(window_spec))
    .filter(F.col("decile") == 10)
    .select(
        "mdl_name",
        "accuracy",
        F.abs(F.col("accuracy") - 0.95).cast("float").alias("accuracy_gap"),
    )
)
