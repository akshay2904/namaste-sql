"""PySpark solution for: Silent Users
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (users
          .join(search_queries, "user_id", "left")
          .filter(F.col("query_id").isNull())
          .select("username", "signup_date")
          .orderBy(F.col("signup_date").desc())
         )
