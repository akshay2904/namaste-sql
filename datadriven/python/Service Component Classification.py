"""PySpark solution for: Service Component Classification
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import when, col

# Classification function: checks for '/' in svc_name
classify_svc = when(col("svc_name").contains('/'), "Multi-Component").otherwise("Single-Component")

# Enrich and select distinct service names with classification
result = svc_health \
    .select("svc_name") \
    .distinct() \
    .withColumn("svc_class", classify_svc)

# Optional: Display result (for verification, remove in production)
result.show()
