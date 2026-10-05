"""PySpark solution for: Error Hall of Fame
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Group by lowercased error type, sum counts, and sort by occurrences descending
# then by error type ascending for deterministic tie-breaking
result = (err_tracks
    .withColumn("error_type", F.lower(F.col("err_type")))
    .groupBy("error_type")
    .agg(F.sum("count").alias("occurrences"))
    .orderBy(F.col("occurrences").desc(), F.col("error_type").asc())
)

result.select("error_type", "occurrences").show()
