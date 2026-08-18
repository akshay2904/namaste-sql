"""PySpark solution for: Left On
Auto-translated from the SQL solution in the matching .sql file."""

import pyspark.sql.functions as F
from pyspark.sql import Window

# Filter flags created more than 730 days before May 1, 2026
cutoff = F.to_date(F.lit('2026-05-01'))
df_filtered = feat_flags.filter(
    (F.datediff(cutoff, F.col('created')) > 730)
)

# Compute years since creation as integer (floor of days/365)
df_result = df_filtered.select(
    F.col('flag_name'),
    F.col('owner'),
    F.when(
        (F.col('enabled') == 1) | F.col('updated').isNull(), 'Yes'
    ).otherwise('No').alias('still_enabled'),
    F.floor(F.datediff(cutoff, F.col('created')) / 365).alias('years_since_creation')
).orderBy(
    F.col('flag_name'),
    F.col('owner'),
    F.col('years_since_creation').desc(),
    F.col('still_enabled')
)

df_result.show(truncate=False)
