"""PySpark solution for: Echo Chamber
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Self-join to find matching pairs
joined = api_calls.alias("a").join(
    api_calls.alias("b"),
    (F.col("a.method") == F.col("b.method")) &
    (F.col("a.status") == F.col("b.status")) &
    (F.col("a.call_id") < F.col("b.call_id"))
)

# Select the required columns and order by status descending, call_id ascending
result = joined.select(
    F.col("a.call_id").alias("call_id_1"),
    F.col("b.call_id").alias("call_id_2"),
    F.col("a.method"),
    F.col("a.status")
).orderBy(F.col("status").desc(), F.col("call_id_1"), F.col("call_id_2")).limit(20)

result.show()
