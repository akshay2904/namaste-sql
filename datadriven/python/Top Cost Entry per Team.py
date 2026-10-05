"""PySpark solution for: Top Cost Entry per Team
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the ranking window based on team_name
window = Window.partitionBy("team_name").orderBy(F.col("amount").desc())

# Apply ranking and select top-ranked entries per team
result = cost_allocs \
    .withColumn("rnk", F.dense_rank().over(window)) \
    .filter(F.col("rnk") == 1) \
    .select(
        F.upper(F.col("team_name")).alias("team_name"),  # Assuming upper case as in sample output
        F.concat(F.col("svc_name"), F.lit(" - "), F.col("region")).alias("entry_label"),
        F.col("amount")
    ) \
    .orderBy(F.col("team_name"))  # Match SQL's ORDER BY clause

result.show()  # Display the result (optional, for verification)
