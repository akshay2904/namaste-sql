"""PySpark solution for: Who Moved the Needle
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Filter the DataFrame for the specific test and calculate total_value per user
onboarding_v3_results = ab_results.filter(ab_results.test_name == "onboarding_v3") \
    .groupBy("variant", "user_id") \
    .agg(F.sum("value").alias("total_value"))

# Rank users by total_value in descending order
ranked_results = onboarding_v3_results.withColumn(
    "rnk", 
    F.dense_rank().over(Window.orderBy(F.col("total_value").desc()))
)

# Filter top 10 and sort as required
top_ten = ranked_results.filter(F.col("rnk") <= 10) \
    .orderBy(F.col("rnk").asc(), F.col("variant").asc(), F.col("user_id").asc()) \
    .select("rnk", "variant", "user_id", "total_value")

# Display the result (assuming you want to see it, otherwise remove)
top_ten.show()
