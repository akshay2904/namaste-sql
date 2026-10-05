"""PySpark solution for: Peak Hour Power Callers
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F
from pyspark.sql.types import IntegerType

result = (
    api_calls
    .withColumn("hour", F.hour(F.col("call_time").cast("timestamp"))) 
    .filter(F.col("hour").between(15, 17)) 
    .groupBy("user_id") 
    .agg(F.count("*").alias("call_count")) 
    .filter(F.col("call_count") >= 3) 
    .orderBy(F.col("call_count").desc(), F.col("user_id")) 
    .select("user_id", "call_count")
)
result.show()
