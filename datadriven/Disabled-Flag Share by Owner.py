"""PySpark solution for: Disabled-Flag Share by Owner
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (
    feat_flags
    .groupBy("owner")
    .agg(
        F.round(
            F.sum(F.when(F.col("enabled") == 0, 1).otherwise(0)).cast("double") / F.count("*"), 
            3
        ).alias("disabled_ratio")
    )
    .orderBy(F.col("disabled_ratio").desc(), F.col("owner"))
)

result.select("owner", "disabled_ratio").show()
