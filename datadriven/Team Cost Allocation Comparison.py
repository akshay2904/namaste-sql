"""PySpark solution for: Team Cost Allocation Comparison
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Calculate manager's amount (MAX per team)
managers = cost_allocs.groupBy("team_name").agg(F.max("amount").alias("mgr_amount"))

# Window for department average and sorting
dept_window = Window.partitionBy("team_name").orderBy(F.col("amount").desc())

# Main query with joins and aggregations
result = cost_allocs.join(managers, "team_name", "left_outer") \
    .withColumn("dept_avg", F.avg("amount").over(Window.partitionBy("team_name"))) \
    .filter(F.col("amount").isNotNull()) \
    .withColumn("amount", F.col("amount")) \
    .withColumn("manager_amount", F.col("mgr_amount")) \
    .withColumn("dept_avg", F.col("dept_avg")) \
    .orderBy("team_name", F.col("amount").desc()) \
    .select("team_name", "svc_name", "amount", "manager_amount", "dept_avg")

# To match the output case (uppercase team_name)
result = result.withColumn("team_name", F.upper(F.col("team_name")))

# Note: The original SQL's AVG(...) is a window function without ORDER BY, so it doesn't require the dept_window definition for sorting order, only for partitioning. However, the final ORDER BY in SQL suggests sorting by team and amount descending, which is replicated here. 

# If you want to see the result
result.show()
