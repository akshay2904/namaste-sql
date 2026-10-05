"""PySpark solution for: Unclicked Searches by Campaign
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (search_queries
          .join(ad_impressions, "user_id")
          .groupBy("ad_campaign", "clicked_result")
          .agg(F.count("*").alias("event_count"))
          .orderBy("ad_campaign", "clicked_result"))
