-- ======================================================================
-- 160 - IPv4 Validator
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Google
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/160-ipv4-validator
-- ======================================================================

/*
You are given a table logins containing IP addresses as plain text strings.
Each row represents an IP address from a user login attempt. Your task is to validate whether the IP address is a valid IPv4 address or not based on the following criteria:

1- The IP address must contain exactly 4 parts, separated by 3 dots (.).
2- Each part must consist of only numeric digits (no letters or special characters).
3- Each numeric part must be within the inclusive range of 0 to 255.
4- No part should contain leading zeros unless the value is exactly 0.

 
Table: logins
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| ip_address  | VARCHAR  |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
  ip_address,
  CASE 
    WHEN 
      -- Check if exactly 4 parts separated by 3 dots
      (LENGTH(ip_address) - LENGTH(REPLACE(ip_address, '.', ''))) = 3
      AND ip_address NOT LIKE '.%'
      AND ip_address NOT LIKE '%.'
      AND ip_address NOT LIKE '%.%.'
      -- Extract and validate each octet
      AND CAST(SUBSTRING_INDEX(ip_address, '.', 1) AS UNSIGNED) BETWEEN 0 AND 255
      AND CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 2), '.', -1) AS UNSIGNED) BETWEEN 0 AND 255
      AND CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 3), '.', -1) AS UNSIGNED) BETWEEN 0 AND 255
      AND CAST(SUBSTRING_INDEX(ip_address, '.', -1) AS UNSIGNED) BETWEEN 0 AND 255
      -- Validate no leading zeros (part is either '0' or doesn't start with '0')
      AND SUBSTRING_INDEX(ip_address, '.', 1) REGEXP '^(0|[1-9][0-9]*)$'
      AND SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 2), '.', -1) REGEXP '^(0|[1-9][0-9]*)$'
      AND SUBSTRING_INDEX(SUBSTRING_INDEX(ip_address, '.', 3), '.', -1) REGEXP '^(0|[1-9][0-9]*)$'
      AND SUBSTRING_INDEX(ip_address, '.', -1) REGEXP '^(0|[1-9][0-9]*)$'
    THEN 'Valid'
    ELSE 'Invalid'
  END AS validation_status
FROM logins;
```
