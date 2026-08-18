-- ======================================================================
-- Customer Full Name Concat
-- ======================================================================
-- Difficulty : Easy
-- Company    : Amazon
-- Access     : Free
-- Source     : DataDriven.io
-- URL        : https://datadriven.io/problems/customer_full_name_concat
-- ======================================================================

/*
The customer success team needs a clean roster for their outreach emails. Combine each customer's first and last name into a single full name field, and include their ID and country, listed alphabetically by full name.

Table: customers(customer_id, first_name, last_name, country)

Sample data - customers ['customer_id', 'first_name', 'last_name', 'country']:
  [40089, 'Priya', 'Gupta', 'India']
  [40178, 'Luca', 'Rossi', 'Italy']
  [40267, 'Ava', 'Nguyen', 'Vietnam']
  [40356, 'Ethan', 'Johnson', 'Spain']
  [40445, 'Maria', 'Garcia', 'China']

Expected output ['full_name', 'customer_id', 'country']:
  ['Aiden Kim', 42670, 'United States']
  ['Aiden Kim', 49879, 'Bangladesh']
  ['Aiden Smith', 47120, 'Bangladesh']
  ['Aiden Smith', 54329, 'France']
  ['Alexander Brown', 53083, 'Italy']
*/


-- Write your SQL solution below:

SELECT first_name || ' ' || last_name AS full_name, customer_id, country FROM customers ORDER BY full_name, customer_id
