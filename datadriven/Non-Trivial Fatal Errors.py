"""PySpark solution for: Non-Trivial Fatal Errors
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

err_tracks \
    .filter((F.col("severity").isin(["Fatal", "fatal"])) & (F.length("message") >= 25)) \
    .withColumn("length_category", F.when(F.length("message") <= 35, "mid").otherwise("long")) \
    .select("err_id", "message", "svc_name", "length_category")
