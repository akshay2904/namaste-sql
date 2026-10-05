"""PySpark solution for: Users With Admin Tokens
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

result = users.join(api_tokens, users.user_id == api_tokens.owner_id, 'inner') \
               .filter(F.col('scope').like('%admin%')) \
               .select(users.user_id, users.username, users.email, api_tokens.token_id, api_tokens.scope) \
               .orderBy(users.user_id.asc())
