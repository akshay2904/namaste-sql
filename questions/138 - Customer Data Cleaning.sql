-- ======================================================================
-- 138 - Customer Data Cleaning
-- ======================================================================
-- Difficulty : Medium
-- Category   : Analytics
-- Companies  : Tiger analytics
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/138-customer-data-cleaning
-- ======================================================================

/*
You are given a table with customers information that contains inconsistent and messy data. Your task is to clean the data by writing an SQL query to:

 

1- Trim extra spaces from the customer name and email fields.
2- Convert all email addresses to lowercase for consistency.
3- Remove duplicate records based on email address (keep the record with lower customer id).
4- Standardize the phone number format to only contain digits (remove dashes, spaces, and special characters).
5- Replace NULL values in address with 'Unknown'.

Sort the output by customer id.

 
Table: customers
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| customer_id   | int      |
| customer_name | varchar  | 
| email         | varchar  | 
| phone         | varchar  | 
| address       | varchar  | 
+---------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    customer_id,
    TRIM(customer_name) AS customer_name,
    LOWER(TRIM(email)) AS email,
    REGEXP_REPLACE(phone, '[^0-9]', '', 'g') AS phone,
    COALESCE(address, 'Unknown') AS address
FROM customers
WHERE (customer_id, LOWER(TRIM(email))) IN (
    SELECT 
        MIN(customer_id),
        LOWER(TRIM(email))
    FROM customers
    GROUP BY LOWER(TRIM(email))
)
ORDER BY customer_id;
```
