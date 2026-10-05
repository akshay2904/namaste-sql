"""PySpark solution for: Search Algorithm Rating
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

rating_df = search_queries.select("query_id", F.col("clicked_result"), F.col("results_count")) \
    .withColumn("rating", 
                F.when(F.col("clicked_result").isNull(), 1) \
                .when((F.col("clicked_result").isNotNull()) & (F.col("clicked_result") > 3), 2) \
                .when((F.col("clicked_result").isNotNull()) & (F.col("clicked_result") <= 3), 3) \
                .otherwise(None)) \
    .select("query_id", "rating")
