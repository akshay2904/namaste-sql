"""PySpark solution for: Below the Line
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter by severity starting with 'low' (case-sensitive) and year 2026
result = dq_checks.filter(
    F.col('severity').like('low%') & 
    (F.year(F.col('run_at')) == 2026)
).count()

# Create DataFrame with single count value
from pyspark.sql import Row
result_df = spark.createDataFrame([Row(low_severity_count=result)])
