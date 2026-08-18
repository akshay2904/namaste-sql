"""PySpark solution for: Nth Highest Salary Per Department
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

window = Window.partitionBy("department").orderBy(F.col("salary").desc())

result = employees \
    .withColumn("rnk", F.dense_rank().over(window)) \
    .filter(F.col("rnk") == 3) \
    .select("department", "emp_name", "salary")

# if needed to exclude departments with less than 3 employees
result = result.join(
    employees.groupBy("department").count().filter(F.col("count") >= 3),
    on="department",
    how="inner"
).select("department", "emp_name", "salary")
