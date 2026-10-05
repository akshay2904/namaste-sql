"""PySpark solution for: Top Content by Views
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

creator_views = content_items.join(page_views, page_views.user_id == content_items.creator_id) \
    .groupBy(content_items.content_id, content_items.title) \
    .agg(F.count(page_views.view_id).alias("view_count"))

ranked = creator_views.select("title", "view_count") \
    .withColumn("rnk", F.rank().over(Window.orderBy(F.col("view_count").desc()))) 

result = ranked.filter(F.col("rnk") <= 5) \
    .orderBy(F.col("view_count").desc(), F.col("title").asc()) \
    .select("title", "view_count")

result.show()
