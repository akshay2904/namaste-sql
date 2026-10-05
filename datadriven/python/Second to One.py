"""PySpark solution for: Second to One
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Define the window specification
window_spec = Window.partitionBy("department").orderBy(F.col("salary").desc())

# Rank salaries within each department
salary_ranks = employees.withColumn("salary_rank", F.dense_rank().over(window_spec))

# Filter for second highest salary and select distinct departments with their second highest salary
second_highest_salaries = salary_ranks.filter(F.col("salary_rank") == 2).select("department", "salary").distinct()

# Rename and sort the result by department
result = second_highest_salaries.withColumnRenamed("salary", "second_highest_salary").orderBy("department")

result.show()
