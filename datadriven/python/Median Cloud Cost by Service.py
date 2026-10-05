"""PySpark solution for: Median Cloud Cost by Service
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Add row numbers and count per service
window_spec = Window.partitionBy("svc_name").orderBy("amount")
ranked = cloud_costs.withColumn(
    "rn", F.row_number().over(window_spec)
).withColumn(
    "cnt", F.count("*").over(Window.partitionBy("svc_name"))
)

# Filter to the rows that define the median (one or two rows)
median_rows = ranked.filter(
    (F.col("rn") == ((F.col("cnt") + 1) / 2).cast("int")) |
    (F.col("rn") == ((F.col("cnt") + 2) / 2).cast("int"))
)

# Average the selected amounts per service
result = median_rows.groupBy("svc_name").agg(
    F.avg("amount").alias("median_amount")
).orderBy(F.desc("median_amount"), "svc_name")

result.select("svc_name", "median_amount").show()
