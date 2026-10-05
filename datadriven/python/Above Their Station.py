"""PySpark solution for: Above Their Station
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Alias the employees DataFrame for employee (e) and manager (m)
e = employees.alias("e")
m = employees.alias("m")

# Join employee to manager, filter for employees earning more than their manager, and compute gap
result = (
    e.join(m, F.col("e.manager_id") == F.col("m.employee_id"))
    .filter(F.col("e.salary") > F.col("m.salary"))
    .select(
        F.col("e.emp_name").alias("employee_name"),
        F.col("e.salary").alias("employee_salary"),
        F.col("m.emp_name").alias("manager_name"),
        F.col("m.salary").alias("manager_salary"),
        (F.col("e.salary") - F.col("m.salary")).alias("salary_gap")
    )
    .orderBy(F.col("salary_gap").desc())
)
