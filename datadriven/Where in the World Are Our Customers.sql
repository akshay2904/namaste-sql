-- ======================================================================
-- Where in the World Are Our Customers?
-- ======================================================================
-- Difficulty : Medium
-- Company    : N/A
-- Access     : Premium (viewable)
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/us_active_user_share
-- ======================================================================

/*
The go-to-market team keeps insisting the customer base is concentrated in a single country, and we want the real spread before the next planning cycle. Break the customers down by country and give each country's percentage of the whole, biggest share first.

Table: users(user_id, username, email, signup_date, account_status, age_bucket)

Table: customers(customer_id, first_name, last_name, country)

Sample data - users ['user_id', 'username', 'email', 'signup_date', 'account_status', 'age_bucket']:
  [100, 'alice', 'alice@example.com', '2025-02-02', 'inactive', '25-34']
  [197, 'aaron42', 'aaron42@example.com', '2026-03-03', 'suspended', '35-44']
  [294, 'amelia', 'amelia@example.com', '2024-04-04', 'pending_verification', '45-54']
  [391, 'arjun', 'arjun@example.com', '2025-05-05', 'active', '55-64']
  [488, 'ava99', 'ava99@example.com', '2026-06-06', 'inactive', '65+']

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Expected output ['country', 'share_pct']:
  ['France', 4]
  ['Italy', 4]
  ['Australia', 3.5]
  ['Brazil', 3.5]
  ['Argentina', 3]
*/


-- Write your SQL solution below:

SELECT
  country,
  ROUND(CAST(COUNT(*) AS REAL) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS share_pct
FROM customers
GROUP BY country
ORDER BY share_pct DESC, country;
