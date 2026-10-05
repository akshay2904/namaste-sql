"""PySpark solution for: Median Model Accuracy
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Filter out null accuracy and add row numbers and counts per model
window_spec = Window.partitionBy("mdl_name").orderBy("accuracy")
numbered = ml_models.filter(F.col("accuracy").isNotNull()).select(
    "mdl_name",
    "accuracy",
    F.row_number().over(window_spec).alias("rn"),
    F.count("*").over(Window.partitionBy("mdl_name")).alias("cnt")
)

# Filter to median row(s): for even counts, take cnt/2 and cnt/2+1; for odd counts, take (cnt+1)/2
median_rows = numbered.filter(
    (F.col("rn").isin(F.col("cnt") / 2, F.col("cnt") / 2 + 1)) |
    ((F.col("cnt") % 2 == 1) & (F.col("rn") == (F.col("cnt") + 1) / 2))
)

# Group by model and compute average of the selected rows as median
result = median_rows.groupBy("mdl_name").agg(
    F.avg("accuracy").alias("median_accuracy")
).orderBy("mdl_name")

result.show()
