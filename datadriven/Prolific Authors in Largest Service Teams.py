"""PySpark solution for: Prolific Authors in Largest Service Teams
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Step 1: Calculate author counts per service, and find the max count
author_counts = deploy_logs.withColumn("lower_author", F.lower(F.col("author"))) \
    .groupBy("svc_name") \
    .agg(F.countDistinct("lower_author").alias("author_count"))

max_author_count = author_counts.agg(F.max("author_count").alias("max_count"))

# Step 2: Identify services with the max author count
max_services = author_counts.join(max_author_count, author_counts.author_count == max_author_count.max_count, "inner") \
    .select("svc_name")

# Step 3: Filter authors starting with 'a' (case-insensitive) in max services
result = deploy_logs \
    .withColumn("lower_author", F.lower(F.col("author"))) \
    .filter(F.col("lower_author").startswith("a")) \
    .join(max_services, "svc_name") \
    .select("svc_name", "author") \
    .distinct() \
    .orderBy("svc_name", "author")

result.show()
