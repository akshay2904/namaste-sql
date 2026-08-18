"""PySpark solution for: Turned Away
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    rate_limits
    .filter(F.col("blocked").cast("int") > 0)
    .select("client")
    .distinct()
)
