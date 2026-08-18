"""PySpark solution for: Live Wire
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

# Rank flags per owner by most recent update (tie-break by highest flag_id)
window_spec = Window.partitionBy("owner").orderBy(F.col("updated").desc(), F.col("flag_id").desc())
ranked = feat_flags.withColumn("rn", F.row_number().over(window_spec))

result = (ranked
    .filter(F.col("rn") == 1)
    .select("owner", "flag_name", F.col("updated").alias("last_changed"))
    .orderBy(F.col("last_changed").desc())
)

result.show()
