"""PySpark solution for: Unmatched Deploy Services
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import col

# Get distinct repo names from ci_builds
ci_repo_names = ci_builds.select(col('repo_name')).distinct()

# Filter deploy logs for svc_name not in ci_repo_names and select distinct svc_name
missing_services = deploy_logs.join(ci_repo_names, deploy_logs.svc_name == ci_repo_names.repo_name, 'left_anti')

# Order the result by svc_name
result = missing_services.select('svc_name').orderBy('svc_name').distinct()

# Show the result
result.show()
