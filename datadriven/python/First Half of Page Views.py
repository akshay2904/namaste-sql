"""PySpark solution for: First Half of Page Views
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import Window
from pyspark.sql import functions as F

# Add row number ordered by view_id
w = Window.orderBy("view_id")
df_with_rn = page_views.withColumn("rn", F.row_number().over(w))

# Calculate half the total row count (integer division)
half_count = page_views.count() // 2

# Filter to first half and order by view_id
result = df_with_rn.filter(F.col("rn") <= half_count).orderBy("view_id")

result.show()
