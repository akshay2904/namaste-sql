"""PySpark solution for: Mutual Channel Connections
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Get channels posted by user 197 and 585
channels_197 = chat_msgs.filter(chat_msgs.sender_id == 197).select("channel").distinct()
channels_585 = chat_msgs.filter(chat_msgs.sender_id == 585).select("channel").distinct()

# Find senders in channels posted by 197 (excluding 197)
senders_in_197_channels = chat_msgs.join(channels_197, "channel", "inner").filter(~F.col("sender_id").isin([197, 585])).select("sender_id").distinct()

# Find senders in channels posted by 585 (excluding 585 and 197)
senders_in_585_channels = chat_msgs.join(channels_585, "channel", "inner").filter(~F.col("sender_id").isin([197, 585])).select("sender_id").distinct()

# Find common senders in both sets (excluding 197 and 585)
common_senders = senders_in_197_channels.intersect(senders_in_585_channels)

# Select distinct sender_ids
result = common_senders.select("sender_id").distinct()
