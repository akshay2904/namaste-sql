"""PySpark solution for: The Long Watch
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

prod_deploys = deploy_logs.filter((F.lower(F.col('env_name')) == 'production') & (F.lower(F.col('status')) == 'success'))

w = Window.partitionBy(F.col('svc_name')).orderBy(F.col('deploy_at'))

lifespans = prod_deploys.withColumn('next_deploy_at', F.lead('deploy_at').over(w))

result = lifespans.filter(F.col('next_deploy_at').isNotNull()) \
                   .withColumn('days_live', F.datediff(F.col('next_deploy_at'), F.col('deploy_at'))) \
                   .select('svc_name', 'version', 'days_live') \
                   .orderBy(F.col('days_live').desc(), F.col('svc_name'), F.col('deploy_at'))
