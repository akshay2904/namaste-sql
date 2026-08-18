"""PySpark solution for: Tenure Mentorship Match
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification to rank authors by deployment time within each service
window_spec = Window.partitionBy("svc_name").orderBy(F.col("deploy_at"))

# Ensure deploy_at is of timestamp type (assuming it's currently a string)
deploy_logs = deploy_logs.withColumn("deploy_at", F.to_timestamp("deploy_at"))

# Assign row numbers based on the window specification
svc_senior = deploy_logs.withColumn("rn", F.row_number().over(window_spec)).\
    withColumn("most_tenured_author", F.col("author")).\
    filter(F.col("rn") == 1).select("svc_name", "most_tenured_author")

# Join the original deploy_logs with the svc_senior DataFrame
result = deploy_logs.alias("e").join(svc_senior.alias("s"), on="svc_name").\
    select("e.author", "e.svc_name", "s.most_tenured_author").\
    orderBy("e.svc_name", "e.author", "e.log_id")

# Show the result
result.show()
