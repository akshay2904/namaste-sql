"""PySpark solution for: Successful Build Duration by Repository
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# Get distinct repo names
repos = ci_builds.select('repo_name').distinct()

# Filter successful builds in January 2026 and calculate total duration
successful_builds = ci_builds.filter(
    (ci_builds.status == 'success') & 
    (ci_builds.built_at >= '2026-01-01') & 
    (ci_builds.built_at <= '2026-01-31')
).groupBy('repo_name').agg(F.sum('dur_secs').alias('total_dur_secs'))

# Left join and fill missing values with 0
result = repos.join(successful_builds, ['repo_name'], 'left_outer').select(
    'repo_name', 
    F.coalesce('total_dur_secs', F.lit(0)).alias('total_dur_secs')
)
