"""PySpark solution for: Presence vs. Participation
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

active_users = users.filter(F.col("account_status") == "active").count()
us_east_nodes = infra_nodes.filter(F.col("region") == "us-east-1").count()

result_df = spark.createDataFrame(
    [("More active" if active_users > us_east_nodes else "More us-east-1",)], 
    ["result"]
)
result_df.show()
