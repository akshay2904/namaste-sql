"""PySpark solution for: The Weight of Words
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

chat_msgs.withColumn("word_count", F.size(F.split(F.col("content"), " ")) - F.when(F.col("content") == "", 1).otherwise(0) + 1) \
         .select("msg_id", "word_count") \
         .show()
