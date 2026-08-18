"""PySpark solution for: The Blind Spot
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Find all pairs of users who have posted in the same channel
friends = chat_msgs.alias("cm1") \
    .join(chat_msgs.alias("cm2"), 
          (F.col("cm1.channel") == F.col("cm2.channel")) & 
          (F.col("cm1.sender_id") != F.col("cm2.sender_id"))) \
    .select(F.col("cm1.sender_id").alias("user_id"), 
            F.col("cm2.sender_id").alias("friend_id")) \
    .distinct()

# Distinct pages each user has viewed
user_views = page_views.select("user_id", 
                               F.col("page_url").alias("content_id")) \
    .distinct()

# Pages viewed by friends of each user
friend_views = friends.join(user_views, 
                            user_views.user_id == friends.friend_id) \
    .select(friends.user_id, user_views.content_id) \
    .distinct()

# Find pages friends viewed that the user hasn't viewed themselves
result = friend_views.alias("fv") \
    .join(user_views.alias("uv"), 
          (F.col("uv.user_id") == F.col("fv.user_id")) & 
          (F.col("uv.content_id") == F.col("fv.content_id")), 
          "left") \
    .where(F.col("uv.content_id").isNull()) \
    .select(F.col("fv.user_id"), F.col("fv.content_id")) \
    .distinct() \
    .orderBy("user_id", "content_id")

result.show()
