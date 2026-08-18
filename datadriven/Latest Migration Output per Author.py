"""PySpark solution for: Latest Migration Output per Author
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
import pyspark.sql.functions as F

window_spec = Window.partitionBy("author").orderBy(F.col("applied").desc(), F.col("migr_id").desc())

result = (
    migrations
    .withColumn("rn", F.row_number().over(window_spec))
    .filter(F.col("rn") == 1)
    .select("author", "version", "applied")
    .orderBy("author")
)

result.show()
