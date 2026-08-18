"""PySpark solution for: Chain of Command
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql.functions import col, concat_ws, lit

# Start with roots (manager_id IS NULL)
result = employees.filter(col("manager_id").isNull()) \
    .select(col("employee_id"), col("emp_name"), lit(0).alias("depth"), col("emp_name").alias("path"))

# Iteratively join children until no new rows are added
prev_count = -1
curr_count = result.count()
while prev_count != curr_count:
    prev_count = curr_count
    new_rows = employees.alias("e") \
        .join(result.alias("t"), col("e.manager_id") == col("t.employee_id")) \
        .select(
            col("e.employee_id"),
            col("e.emp_name"),
            (col("t.depth") + 1).alias("depth"),
            concat_ws("/", col("t.path"), col("e.emp_name")).alias("path")
        )
    result = result.union(new_rows)
    curr_count = result.count()

# Order by path, employee_id
result = result.orderBy("path", "employee_id")
result.select("employee_id", "emp_name", "depth", "path")
