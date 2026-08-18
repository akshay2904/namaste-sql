"""PySpark solution for: Creator Favorite Content Type
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F, Window

type_counts = (
    content_items
    .groupBy("creator_id", "content_type")
    .agg(F.count("*").alias("cnt"))
    .withColumn(
        "rnk",
        F.rank().over(
            Window.partitionBy("creator_id").orderBy(F.col("cnt").desc())
        )
    )
)

result = (
    type_counts
    .filter(F.col("rnk") == 1)
    .select("creator_id", "content_type")
)
