"""PySpark solution for: Rooms in Common
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql.functions import countDistinct

# Self-join chat_msgs on channel, excluding same sender_id
connections = chat_msgs.alias('a').join(chat_msgs.alias('b'), 
                                        (chat_msgs.channel == chat_msgs.channel) & 
                                        (chat_msgs.sender_id != chat_msgs.sender_id), 
                                        'inner')

# Group by sender_id and count distinct connections
mutual_connections = connections.groupBy('a.sender_id').agg(countDistinct('b.sender_id').alias('mutual_connections'))

# Order by mutual_connections in descending order
result = mutual_connections.orderBy('mutual_connections', ascending=False)
