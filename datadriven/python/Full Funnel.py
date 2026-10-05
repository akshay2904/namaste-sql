"""PySpark solution for: Full Funnel
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Combine user IDs from all three activities with area labels
search_df = search_queries.select("user_id").withColumn("area", F.lit("search"))
browse_df = page_views.select("user_id").withColumn("area", F.lit("browse"))
purchase_df = transactions.select("user_id").withColumn("area", F.lit("purchase"))

all_areas = search_df.unionAll(browse_df).unionAll(purchase_df)

# Join with users and filter for users with all 3 distinct areas
result = users.alias("u") \
    .join(all_areas.alias("a"), F.col("u.user_id") == F.col("a.user_id"), "inner") \
    .groupBy(F.col("u.user_id"), F.col("u.username")) \
    .agg(F.countDistinct("area").alias("area_count")) \
    .filter(F.col("area_count") == 3) \
    .select("username") \
    .orderBy("username")

result.show()
