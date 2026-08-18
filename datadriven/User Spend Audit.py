"""PySpark solution for: User Spend Audit
Auto-translated from the SQL solution in the matching .sql file."""

from pyspark.sql import functions as F

# Filter users DataFrame for 'alice'
alice_user = users.filter(users.username == 'alice')

# Join users, transactions, and products DataFrames
joined_df = alice_user.join(transactions, alice_user.user_id == transactions.user_id) \
                     .join(products, transactions.product_id == products.product_id)

# Filter for Electronics products with rating > 3 and calculate total spend
total_spend = joined_df.filter((products.category == 'Electronics') & (products.rating > 3)) \
                       .groupBy() \
                       .agg(F.sum(transactions.total_amount).alias('total_spend'))

# Print the result
total_spend.show()
