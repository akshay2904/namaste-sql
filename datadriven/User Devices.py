"""PySpark solution for: User Devices
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = (users
          .join(user_sessions, users.user_id == user_sessions.user_id, 'inner')
          .join(devices, user_sessions.device_id == devices.device_id, 'inner')
          .select(users.username, devices.device_type)
          .distinct())

result.show()
