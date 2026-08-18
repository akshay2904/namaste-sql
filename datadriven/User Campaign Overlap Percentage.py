"""PySpark solution for: User Campaign Overlap Percentage
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import Window

# CTE equivalent: user_campaigns
user_campaigns = ad_impressions.select('user_id', 'ad_campaign').distinct()

# CTE equivalent: user_counts
user_counts = user_campaigns.groupBy('user_id').agg(F.count('*').alias('campaign_count'))

# Main Query
result = (user_campaigns.alias('a')
          .join(user_campaigns.alias('b'), 
                (F.col('a.ad_campaign') == F.col('b.ad_campaign')) & 
                (F.col('a.user_id') < F.col('b.user_id')), 'inner')
          .join(user_counts.alias('uc1'), F.col('a.user_id') == F.col('uc1.user_id'), 'inner')
          .join(user_counts.alias('uc2'), F.col('b.user_id') == F.col('uc2.user_id'), 'inner')
          .groupBy('a.user_id', 'b.user_id', 'uc1.campaign_count', 'uc2.campaign_count')
          .agg(F.count('*').alias('shared_campaigns'))
          .withColumn('overlap_ratio', 
                       F.col('shared_campaigns') / F.least(F.col('uc1.campaign_count'), F.col('uc2.campaign_count')))
          .withColumn("overlap_ratio", F.round(F.col("overlap_ratio"), 4)) # avoid floating point inaccuracies
          .filter(F.col('shared_campaigns') >= 1)
          .select(F.col('a.user_id').alias('user_id_1'),
                  F.col('b.user_id').alias('user_id_2'),
                  F.col('shared_campaigns'),
                  F.col('overlap_ratio'))
         )

# Final output with integer ratio where possible (as per sample output hint)
result = result.withColumn('overlap_ratio', 
                           F.when(F.col('overlap_ratio').cast('float') == F.col('overlap_ratio').cast('int'), 
                                  F.col('overlap_ratio').cast('int'))
                           .otherwise(F.col('overlap_ratio').cast('float')))

result.show()
