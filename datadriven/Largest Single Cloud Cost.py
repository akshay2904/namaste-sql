"""PySpark solution for: Largest Single Cloud Cost
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Order by amount descending, then by svc_name ascending, and take the first row
result = cloud_costs.orderBy(F.col("amount").desc(), F.col("svc_name").asc()).select("svc_name", "amount").limit(1)

result.show()
