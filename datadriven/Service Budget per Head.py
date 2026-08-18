"""PySpark solution for: Service Budget per Head
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Inner join cloud_costs and cost_allocs on svc_name
joined_df = cloud_costs.join(cost_allocs, cloud_costs.svc_name == cost_allocs.svc_name, "inner")

# Group by svc_name, sum allocated amount, count distinct teams, and calculate budget per head
budget_per_head_df = joined_df.groupBy(cloud_costs.svc_name) \
    .agg(F.sum(cost_allocs.amount).alias("total_amount"), F.countDistinct(cost_allocs.team_name).alias("team_count")) \
    .withColumn("budget_per_head", F.round(F.col("total_amount") / F.col("team_count")))

# Select and order by budget per head in descending order
result_df = budget_per_head_df.select(cloud_costs.svc_name.alias("svc_name"), "budget_per_head").orderBy("budget_per_head", ascending=False)
