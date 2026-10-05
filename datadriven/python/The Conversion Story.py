"""PySpark solution for: The Conversion Story
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Define a UDF to classify the referral source
classify_referral_source = F.udf(
    lambda tags: 
        'organic' if 'organic' in tags 
        else 'referral' if 'referral' in tags 
        else 'campaign_a' if 'campaign_a' in tags 
        else 'campaign_b' if 'campaign_b' in tags 
        else 'other',
    returnType='string'
)

# Filter and classify the event data
src = event_data.filter(F.col('event_type').isin(['signup', 'purchase'])) \
                .withColumn('referral_source', classify_referral_source(F.col('tags')))

# Calculate the conversion rate
result = src.groupBy('referral_source') \
            .agg(
                F.countDistinct(F.when(F.col('event_type') == 'signup', F.col('user_id'))).alias('signup_count'),
                F.countDistinct(F.when(F.col('event_type') == 'purchase', F.col('user_id'))).alias('purchase_count')
            ) \
            .withColumn('conversion_rate', 
                        F.round(F.col('purchase_count') * 1.0 / F.col('signup_count'), 4)) \
            .filter(F.col('signup_count') > 0) \
            .orderBy('referral_source')

# Select the desired columns
result = result.select('referral_source', 'signup_count', 'purchase_count', 'conversion_rate')
