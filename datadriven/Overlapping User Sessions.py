"""PySpark solution for: Overlapping User Sessions
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql import DataFrame

def overlapping_sessions(user_sessions: DataFrame) -> DataFrame:
    # Convert session_start to timestamp and calculate session end
    user_sessions = user_sessions.withColumn("session_start", F.col("session_start").cast("timestamp"))
    user_sessions = user_sessions.withColumn("session_end", F.col("session_start") + F.expr("interval session_duration_sec seconds"))

    # Self-join on user_id, ensuring session_id_1 < session_id_2
    overlapping = user_sessions.alias("a").join(user_sessions.alias("b"), 
                                                  (F.col("a.user_id") == F.col("b.user_id")) & 
                                                  (F.col("a.session_id") < F.col("b.session_id")), 
                                                  "inner")

    # Filter for overlapping sessions
    overlapping = overlapping.filter((F.col("a.session_start") < F.col("b.session_end")) & 
                                      (F.col("b.session_start") < F.col("a.session_end")))

    # Select desired columns
    overlapping = overlapping.select(F.col("a.user_id"), 
                                      F.col("a.session_id").alias("session_id_1"), 
                                      F.col("b.session_id").alias("session_id_2"), 
                                      F.col("a.session_start").alias("start_1"), 
                                      F.col("b.session_start").alias("start_2"))

    return overlapping
