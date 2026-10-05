"""PySpark solution for: The Open Question
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (push_notifs
          .groupBy(F.to_date("sent_at").alias("send_date"))
          .agg(F.sum("opened").alias("opened_sum"), F.count("*").alias("total_count"))
          .withColumn("open_rate", F.col("opened_sum") / F.col("total_count"))
          .filter(F.col("opened_sum") > 0)
          .select("send_date", "open_rate"))
